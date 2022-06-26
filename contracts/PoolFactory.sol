//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Pool.sol";
contract PoolFactory {

    event PoolCreated(address poolAddr, string _poolName, uint256 _endDate, address _viralityOracle);

    function createPool(string memory _poolName, uint256 _endDate, address _viralityOracle) external {
        Pool pool = new Pool(_poolName, _endDate, _viralityOracle);
        emit PoolCreated(address(pool), _poolName, _endDate, _viralityOracle);
    }
}