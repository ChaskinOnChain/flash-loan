// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FlashLoan.sol";
import "./Token.sol";

contract FlashLoanReciever {
    FlashLoan public pool;
    address private owner;

    event LoanReceived(address indexed token, uint256 amount);

    constructor(address _poolAddress) {
        pool = FlashLoan(_poolAddress);
        owner = msg.sender;
    }

    function receiveTokens(address _tokenAddress, uint256 _amount) external {
        require(msg.sender == address(pool), "sender must be pool");
        require(
            (Token(_tokenAddress).balanceOf((address(this))) == _amount),
            "Failed to get loan"
        );
        emit LoanReceived(_tokenAddress, _amount);

        // DO SOME STUFF

        // Return Loan
        require(
            Token(_tokenAddress).transfer(msg.sender, _amount),
            "Failed to send back"
        );
    }

    function executeFlashLoan(uint256 _amount) external {
        require(msg.sender == owner, "only owner can call");
        pool.flashLoan(_amount);
    }
}
