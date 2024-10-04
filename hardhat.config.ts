import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

require("dotenv").config();

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    "lisk-sepolia": {
      url: process.env.LISK_RPC_URL,
      accounts: [process.env.PRIVATE_KEY!],
      gasPrice: 1000000000,
    },
    
  },

  etherscan: {
    apiKey: '123',
    customChains: [
      {
          network: 'lisk-sepolia',
          chainId: 4202,
          urls: {
              apiURL: "https://sepolia-blockscout.lisk.com/api",
              browserURL: "https://sepolia-blockscout.lisk.com"
          }
      }
    ]
  },
  sourcify: {
    enabled: false
  },
  
  
};

export default config;
