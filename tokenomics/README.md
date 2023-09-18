# Tokenomics 
A central location to store all tokenomic scripts, data, and documentation that doesn't fall under other repos or directories. 

## GNOT Fee Equation & Simulation

[Fee Equation Spreadsheet](https://docs.google.com/spreadsheets/d/16LdahdcIRMHNQXULCSeO90PGbHTbZbuefwDVbDeKpWk/edit?usp=sharing)

In order to test variants of the GNOT/Gno.land fee equation, a number of scripts, simulations, and files have been created to aid in the process. Async/concurrency has been added to reduce request time from a week to roughly 4 hours per chain. 

- A series of scripts and queries utilizing Etherscan, Infura, and a Chainstack node that pull block data from ETH and similar smart contract platforms/L1s before exporting to a CSV.
  - Fee data will be used to weight the GNOT fee simulations, resulting in a more realistic distribution. Wei Ethereum data is then converted to Gwei to better align with GNOT notation.
  - Gas limit, gas used, the percentage used out of the max, median wei price, and median gwei price are all scrapped and added to a CSV. The percentage of gas used each block will be used to weight the GNOT fee equation's network congestion metric during simulations. 
  
- Once the base Gno.land fee equation is finalized, a Monte Carlo simulation will be created to test a number of Gno.land network conditions. This includes testing against exploits such as spam attacks, various levels of network congestion, etc. Individual parameters within the fee equation such as CPU cycles required, bytes stored, and the threshold at which fee cost begins increasing exponentially (to combat exploits) will also be tested. 

If for any reason the Monte Carlo simulation does not provide adequate insight, a separate Cartesian Product simulation may be created to brute force additional results. By virtue of testing every possible parameter input against every other parameter input, a Cartesian Product sim can further substantiate any findings as necessary (trading efficiency for thoroughness). 
