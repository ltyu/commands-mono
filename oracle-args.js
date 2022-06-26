const oracleAddr = "0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8";
const jobId = "ca98366cc7314957b8c012c72f05aeeb";
const linkAddr = "0xa36085F69e2889c224210F603D836748e7dC0088";
module.exports = [
    oracleAddr, ethers.utils.toUtf8Bytes(jobId), linkAddr
]