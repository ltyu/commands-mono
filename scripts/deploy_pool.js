// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  const Pool = await hre.ethers.getContractFactory("PoolFactory");
  const pool = await Pool.deploy();

  await pool.createPool("Best Coven Lore 2", 1658796048, '0x0bFBFC559Bb6465EDf5b0B2C2ccD44f60c8dce44');
  console.log('Pool created');
  //string memory _poolName, uint256 _endDate, address _viralityOracle
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
