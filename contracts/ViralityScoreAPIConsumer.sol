// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

/**
 * @title The ViralityScoreAPIConsumer contract
 * @notice An API Consumer contract that makes GET requests to obtain virality score from API
 */
contract ViralityScoreAPIConsumer is ChainlinkClient {
  using Chainlink for Chainlink.Request;

  uint256 public viralityScore;
  address private immutable oracle;
  bytes32 private immutable jobId;
  uint256 private immutable fee;

  event DataFullfilled(uint256 viralityScore);

  /**
   * @notice Executes once when a contract is created to initialize state variables
   *
   * @param _oracle - address of the specific Chainlink node that a contract makes an API call from
   * @param _jobId - specific job for :_oracle: to run; each job is unique and returns different types of data
   * @param _link - LINK token address on the corresponding network
   *
   * Network: Polygon Mumbai Testnet
   * Oracle: 0x58bbdbfb6fca3129b91f0dbe372098123b38b5e9
   * Job ID: da20aae0e4c843f6949e5cb3f7cfe8c4
   * LINK address: 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
   * Fee: 0.01 LINK
   */
  constructor(
    address _oracle,
    bytes32 _jobId,
    address _link
  ) {
    if (_link == address(0)) {
      setPublicChainlinkToken();
    } else {
      setChainlinkToken(_link);
    }
    oracle = _oracle;
    jobId = _jobId;
    fee = 0.1 * 10 ** 18;
  }

  /**
   * @notice Creates a Chainlink request to retrieve API response
   * @return requestId - id of the request
   */
  function requestViralityScore() public returns (bytes32 requestId) {
    Chainlink.Request memory request = buildChainlinkRequest(
      jobId,
      address(this),
      this.fulfill.selector
    );

    // Set the URL to perform the GET request on
    request.add("get", "https://www.random.org/integers/?num=1&min=1&max=6&col=1&base=10&format=plain");
    // Sends the request
    return sendChainlinkRequestTo(oracle, request, fee);
  }

  /**
   * @notice Receives the response in the form of uint256
   *
   * @param _requestId - id of the request
   * @param _viralityScore - response; virality score
   */
  function fulfill(bytes32 _requestId, uint256 _viralityScore)
    public
    recordChainlinkFulfillment(_requestId)
  {
    viralityScore = _viralityScore;
    emit DataFullfilled(viralityScore);
  }

  /**
   * @notice Witdraws LINK from the contract
   * @dev Implement a withdraw function to avoid locking your LINK in the contract
   */
  function withdrawLink() external {}
}
