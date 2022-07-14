import * as dotenv from "dotenv";
import "@nomiclabs/hardhat-ethers"
import { HardhatUserConfig } from "hardhat/config";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.12",
  networks: {
    ropsten: {
      url: "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
  }
};

export default config;
