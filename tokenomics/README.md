# Tokenomics 
A central location to store all tokenomic scripts, data, and documentation that doesn't fall under other repos or directories. 

## GNOT Fee Equation & Simulation

In order to test variants of the GNOT/Gno.land fee equation, a number of scripts, simulations, and files have been created to aid in the process.

- A series of scripts and queries utilizing Etherscan, Infura, and a Chainstack node that pull block data from ETH and similar smart contract platforms/L1s before exporting to a CSV.
  - Fee data will be used to weight the GNOT fee simulations, resulting in a more realistic distribution. Wei Ethereum data is then converted to Gwei to better align with GNOT notation.
  
- Once the base Gno.land fee equation is finalized, a Monte Carlo simulation will be created to test a number of Gno.land network conditions. This includes testing against exploits such as spam attacks, various levels of network congestion, etc. Individual parameters within the fee equation such as CPU cycles required, bytes stored, and the threshold at which fee cost begins increasing expotentially (to combat exploits) will also be tested. 

If for any reason the Monte Carlo simulation does not provide adoquete insight, a seperate Cartesian Product simulation may be created to brute force additional results. By virtue of testing every possible parameter input against every other parameter input, a Cartesian Product sim can further substantiate any findings as necessary (trading efficiency for thoroughness). 
