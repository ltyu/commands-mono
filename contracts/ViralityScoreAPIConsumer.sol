// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

/**
 * @title The ViralityScoreAPIConsumer contract
 * @notice An API Consumer contract that makes GET requests to obtain virality score from API
 */
contract ViralityScoreAPIConsumer is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    uint256 public viralityScore;
    bytes32 private jobId;
    uint256 private fee;

    event RequestviralityScore(bytes32 indexed requestId, uint256 viralityScore);

    /**
     * @notice Initialize the link token and target oracle
     */
    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkOracle(0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8); // Todo: Harcoded for now
        setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088); // Todo: Harcoded for now
        jobId = "ca98366cc7314957b8c012c72f05aeeb"; // Todo: Harcoded for now
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job) // Todo: Harcoded for now
    }

    /**
     * Create a Chainlink request to retrieve API response, find the target
     */
    function requestviralityScoreData() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        // Set the URL to perform the GET request on
        req.add("get", "http://www.randomnumberapi.com/api/v1.0/random?min=1&max=100&count=1");

        // Set the path to find the desired data in the API response, where the response format is:
        req.add("path", "VIRALITYSCORE.0"); // Chainlink nodes 1.0.0 and later support this format


        // Sends the request
        return sendChainlinkRequest(req, fee);
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfill(bytes32 _requestId, uint256 _viralityScore) public recordChainlinkFulfillment(_requestId) {
        emit RequestviralityScore(_requestId, _viralityScore);
        viralityScore = _viralityScore;
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
    }
}
