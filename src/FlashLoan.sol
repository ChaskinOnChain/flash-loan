// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Token.sol";
import "forge-std/console2.sol";

interface IReceiver {
    function recieveTokens(address tokenAddress, uint256 amount) external;
}

contract FlashLoan {
    Token public token;
    uint256 public poolBalance;

    constructor(address _tokenAddress) {
        token = Token(_tokenAddress);
    }

    function depositTokens(uint256 _amount) external {
        require(_amount > 0, "Must deposit at least one token");
        token.transferFrom(msg.sender, address(this), _amount);
        poolBalance = poolBalance + _amount;
    }

    function flashLoan(uint256 _borrowAmount) external {
        token.transfer(msg.sender, _borrowAmount);
        IReceiver(msg.sender).recieveTokens(address(token), _borrowAmount);
    }
}
