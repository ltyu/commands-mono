const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", () => {
  let pool;
  let owner;
  beforeEach(async () => {
    [owner, contentCreator, viralityOracle] = await ethers.getSigners();
    const Pool = await ethers.getContractFactory("Pool");
    pool = await Pool.deploy(await ethers.provider.getBlockNumber() + 60, viralityOracle.address);
    await pool.deployed();
    
    // Initial deposit into the pool
    await pool.connect(owner).deposit({ value: ethers.utils.parseEther("100") });
  });
  
  xit("Should not be able to claim before end date", async () => {
    // TODO after hackathon since this will fail during demo
  });

  it("Should be able to claim an amount based on virality score", async () => {
    expect(await ethers.provider.getBalance(pool.address)).to.equal(ethers.utils.parseEther("100"));
    const balanceBeforeClaim = await ethers.provider.getBalance(pool.address);
    await pool.connect(contentCreator).claim();
    const balanceAfterClaim = await ethers.provider.getBalance(pool.address);

    expect(balanceAfterClaim).to.be.lt(balanceBeforeClaim);
  });
});
