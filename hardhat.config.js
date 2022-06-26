require("dotenv").config();

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("solidity-coverage");
const { accounts } = require("./test-wallet");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: "0.8.4",
  etherscan: {
    apiKey: {
      mainnet: process.env.ETHERSCAN_API_KEY,
      kovan: process.env.ETHERSCAN_API_KEY,
    },
  },
  networks: {
    kovan: {
      url: `https://kovan.infura.io/v3/a06b6ad73bb746628f4c47ac1d6c8afe`,
      accounts: [`${process.env.KOVAN_PRIVATE_KEY}`],
      loggingEnabled: true,

    },
    hardhat: { 
      hardfork: 'london',
      blockGasLimit: 8000000,
      gas: 8000000,
      gasPrice: 8000000000,
      loggingEnabled: true,
      throwOnTransactionFailures: true,
      throwOnCallFailures: true,
      accounts: accounts.map(({ secretKey, balance }) => ({
        privateKey: secretKey,
        balance,
      })),
      forking: {
        url: `https://kovan.infura.io/v3/a06b6ad73bb746628f4c47ac1d6c8afe`,
      }
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
