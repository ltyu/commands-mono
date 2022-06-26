// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  const Pool = await hre.ethers.getContractFactory("Pool");
  
  const pool = await Pool.deploy(1658796048, '0x0bFBFC559Bb6465EDf5b0B2C2ccD44f60c8dce44');

  await pool.deployed();
  
  console.log("Pool deployed to:", pool.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
