//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./ViralityScoreAPIConsumer.sol";
import "hardhat/console.sol";

contract Pool {
    string public poolName;
    uint256 public endDate;
    address public viralityOracle;
    
    event Claimed(address claimerAddress, uint256 amount);
    event Deposited(uint256 amount);

    constructor(string memory _poolName, uint256 _endDate, address _viralityOracle) {
        poolName = _poolName;
        endDate = _endDate;
        viralityOracle = _viralityOracle;
    }
    // Allows the owner to deposit a bounty into the pool
    // TODO make ownable
    function deposit() payable external {

        emit Deposited(msg.value);
    }

    // Allows a content creater to claim their bounty
    // Uses their msg.sender to look up the score using the virality oracle
    // TODO only NFT owners should be able to claim
    function claim() external {
        // TODO Enable AFTER the Hackathon as this method will fail during demo
        // require(block.timestamp >= endDate, "Unclaimable before end date");

        // Requests the Virality Score via Chainlink
        uint256 score = ViralityScoreAPIConsumer(viralityOracle).viralityScore();
        uint256 claimable = address(this).balance * score / 100;
        payable(msg.sender).transfer(claimable);
        emit Claimed(msg.sender, claimable);
    }
}
