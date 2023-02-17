// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/FlashLoan.sol";
import "../src/FlashLoanReceiver.sol";
import "../src/Token.sol";

contract CounterTest is Test {
    FlashLoan public flashLoan;
    FlashLoanReciever public flashLoanReciever;
    Token public token;
    address public alice = address(0x123);

    function setUp() public {
        token = new Token("Soup Token", "SOUP", 1000000);
        flashLoan = new FlashLoan(address(token));
        token.approve(address(flashLoan), 1000000);
        flashLoan.depositTokens(1000000);
        flashLoanReciever = new FlashLoanReciever(address(flashLoan));
    }

    function testSendTokensToFlashLoanPoolContract() public {
        assertEq(token.balanceOf(address(flashLoan)), 1000000);
    }

    function testBorrowingFunds() public {
        flashLoanReciever.executeFlashLoan(100);
    }
}
