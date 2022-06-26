// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  // Deploy chainlink oracle
  //  * Network: Polygon Mumbai Testnet
  //  * Oracle: 0x74EcC8Bdeb76F2C6760eD2dc8A46ca5e581fA656
  //  * Job ID: da20aae0e4c843f6949e5cb3f7cfe8c4
  //  * LINK address: 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
  //  * Fee: 0.01 LINK
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const oracleAddr = "0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8";
  const jobId = "ca98366cc7314957b8c012c72f05aeeb";
  const linkAddr = "0xa36085F69e2889c224210F603D836748e7dC0088";

  const ViralityScoreAPIConsumer = await hre.ethers.getContractFactory("ViralityScoreAPIConsumer");
  
  const viralityScoreAPIConsumer = await ViralityScoreAPIConsumer.deploy(oracleAddr, ethers.utils.toUtf8Bytes(jobId), linkAddr);

  await viralityScoreAPIConsumer.deployed();
  
  console.log("Virality deployed to:", viralityScoreAPIConsumer.address);

  await viralityScoreAPIConsumer.requestViralityScore({ gasLimit: 8000000 });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
