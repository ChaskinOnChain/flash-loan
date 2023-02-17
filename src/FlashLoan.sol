// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Token.sol";
import "forge-std/console2.sol";
import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

interface IReceiver {
    function receiveTokens(address tokenAddress, uint256 amount) external;
}

contract FlashLoan is ReentrancyGuard {
    Token public token;
    uint256 public poolBalance;

    constructor(address _tokenAddress) {
        token = Token(_tokenAddress);
    }

    function depositTokens(uint256 _amount) external nonReentrant {
        require(_amount > 0, "Must deposit at least one token");
        token.transferFrom(msg.sender, address(this), _amount);
        poolBalance = poolBalance + _amount;
    }

    function flashLoan(uint256 _borrowAmount) external nonReentrant {
        require(_borrowAmount > 0, "Must borrow at least one token");

        uint256 balanceBefore = token.balanceOf(address(this));
        require(balanceBefore >= _borrowAmount, "Not enough tokens in pool");

        assert(poolBalance == balanceBefore);

        token.transfer(msg.sender, _borrowAmount);
        IReceiver(msg.sender).receiveTokens(address(token), _borrowAmount);

        uint256 balanceAfter = token.balanceOf(address(this));
        require(
            balanceAfter >= balanceBefore,
            "Flash loan hasn't been paid back"
        );
    }
}
