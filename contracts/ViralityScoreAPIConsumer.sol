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
     *
     * Rinkeby Testnet details:
     * Link Token: 0x01BE23585060835E02B77ef475b0Cc51aA1e0709
     * Oracle: 0xf3FBB7f3391F62C8fe53f89B41dFC8159EE9653f (Chainlink DevRel)
     * jobId: ca98366cc7314957b8c012c72f05aeeb
     *
     */
    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkOracle(0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8); // Todo: Harcoded for now
        setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088); // Todo: Harcoded for now
        jobId = "ca98366cc7314957b8c012c72f05aeeb"; // Todo: Harcoded for now
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job) // Todo: Harcoded for now
    }

    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function requestviralityScoreData() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        // Set the URL to perform the GET request on
        req.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");

        // Set the path to find the desired data in the API response, where the response format is:
        // {"RAW":
        //   {"ETH":
        //    {"USD":
        //     {
        //      "viralityScore24HOUR": xxx.xxx,
        //     }
        //    }
        //   }
        //  }
        // request.add("path", "RAW.ETH.USD.viralityScore24HOUR"); // Chainlink nodes prior to 1.0.0 support this format
        req.add("path", "RAW,ETH,USD,VOLUME24HOUR"); // Chainlink nodes 1.0.0 and later support this format

        // Multiply the result by 1000000000000000000 to remove decimals
        int256 timesAmount = 10**18;
        req.addInt("times", timesAmount);

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
