// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FlashLoan.sol";
import "./Token.sol";

contract FlashLoanReciever {
    FlashLoan public pool;
    address private owner;

    constructor(address _poolAddress) {
        pool = FlashLoan(_poolAddress);
        owner = msg.sender;
    }

    function receiveTokens(address _tokenAddress, uint256 _amount) external {}

    function executeFlashLoan(uint256 _amount) external {
        require(msg.sender == owner, "only owner can call");
        pool.flashLoan(_amount);
    }
}
