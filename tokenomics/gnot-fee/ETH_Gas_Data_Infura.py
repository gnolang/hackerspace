#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import requests
import pandas as pd

def fetch_gas_data_infura(api_key, start_block, end_block):
    base_url = "https://mainnet.infura.io/v3/" + api_key
    headers = {"Content-Type": "application/json"}
    gas_data = []

    for block_num in range(start_block, end_block + 1):
        payload = {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "eth_getBlockByNumber",
            "params": [hex(block_num), True]
        }

        response = requests.post(base_url, headers=headers, json=payload)
        data = response.json()

        if data["result"]:
            block_gas_limit = int(data["result"]["gasLimit"], 16)
            block_gas_used = int(data["result"]["gasUsed"], 16)
            timestamp = int(data["result"]["timestamp"], 16)
            
            tx_gas_prices = [int(tx["gasPrice"], 16) for tx in data["result"]["transactions"]]
            median_gas_price = sorted(tx_gas_prices)[len(tx_gas_prices) // 2] if tx_gas_prices else 0

            gas_data.append({
                "timestamp": timestamp, 
                "block_gas_limit": block_gas_limit,
                "block_gas_used": block_gas_used,
                "median_gas_price": median_gas_price
            })

    return gas_data

API_KEY = "INFURA_API_KEY"
START_BLOCK = 15537393  
END_BLOCK = 17971893  

gas_data = fetch_gas_data_infura(API_KEY, START_BLOCK, END_BLOCK)
df = pd.DataFrame(gas_data)
df.to_csv('ETH_historic_gas_data_infura.csv', index=False)

