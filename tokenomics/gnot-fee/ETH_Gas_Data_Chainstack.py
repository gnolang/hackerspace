#!/usr/bin/env python
# coding: utf-8

# In[1]:


import nest_asyncio
nest_asyncio.apply()
import asyncio
import aiohttp
import pandas as pd

CONCURRENCY_LIMIT = 50  # Adjust this to set the desired concurrency level
semaphore = asyncio.Semaphore(CONCURRENCY_LIMIT)

async def fetch_gas_data_for_block(session, rpc_url, block_num):
    async with semaphore:  # Use the semaphore to limit concurrency
        headers = {"Content-Type": "application/json"}
        payload = {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "eth_getBlockByNumber",
            "params": [hex(block_num), True]
        }

        async with session.post(rpc_url, headers=headers, json=payload) as response:
            if response.headers.get("Content-Type") != "application/json":
                print(f"Unexpected content type for block {block_num}: {response.headers.get('Content-Type')}")
                return {
                    "timestamp": None,
                    "block_gas_limit": None,
                    "block_gas_used": None,
                    "median_gas_price": None,
                    "error": f"Unexpected content type: {response.headers.get('Content-Type')}"
                }
            
            data = await response.json()
            if data["result"]:
                block_gas_limit = int(data["result"]["gasLimit"], 16)
                block_gas_used = int(data["result"]["gasUsed"], 16)
                timestamp = int(data["result"]["timestamp"], 16)
                
                tx_gas_prices = [int(tx["gasPrice"], 16) for tx in data["result"]["transactions"]]
                median_gas_price = sorted(tx_gas_prices)[len(tx_gas_prices) // 2] if tx_gas_prices else 0

                return {
                    "timestamp": timestamp, 
                    "block_gas_limit": block_gas_limit,
                    "block_gas_used": block_gas_used,
                    "median_gas_price": median_gas_price,
                    "error": None
                }
            else:
                return {
                    "timestamp": None,
                    "block_gas_limit": None,
                    "block_gas_used": None,
                    "median_gas_price": None,
                    "error": "No result in response"
                }

async def fetch_gas_data_chainstack(rpc_url, start_block, end_block):
    tasks = []
    async with aiohttp.ClientSession() as session:
        for block_num in range(start_block, end_block + 1):
            task = fetch_gas_data_for_block(session, rpc_url, block_num)
            tasks.append(task)
        return await asyncio.gather(*tasks)

RPC_URL = "ADD_RPC_URL"
START_BLOCK = 15537393  
END_BLOCK = 17971893  

gas_data = asyncio.run(fetch_gas_data_chainstack(RPC_URL, START_BLOCK, END_BLOCK))
df = pd.DataFrame(gas_data)
df['median_gas_price_gwei'] = df['median_gas_price'] / 1e9
df['percentage_used'] = df['block_gas_used'] / df['block_gas_limit']
df = df[['timestamp', 'block_gas_limit', 'block_gas_used', 'percentage_used', 'median_gas_price', 'median_gas_price_gwei', 'error']]
df.to_csv('ETH_historic_gas_data_chainstack.csv', index=False)
