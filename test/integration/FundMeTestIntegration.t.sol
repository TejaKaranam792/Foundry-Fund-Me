// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTestTest is Test {
    FundMe fundMe;

    uint256 constant SEND_VALUE = 0.01 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
    }

    function testUserCanFund() external {
        // Script instance (starts with 0 ETH)
        FundFundMe fundFundMe = new FundFundMe();

        // fund the script so it can forward ETH to FundMe
        vm.deal(address(fundFundMe), 1 ether);

        // USER calls the script, but ETH will be sent by the script contract
        address expectedFunder = address(fundFundMe);

        vm.prank(makeAddr("User"));
        fundFundMe.fundFundMe(address(fundMe));

        // Assert script contract is recorded as funder
        assertEq(fundMe.getFunder(0), expectedFunder);
    }

    function testOwnerCanWithdrawAfterUserFunds() external {
        // --- Arrange ---

        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(address(fundFundMe), 1 ether);

        // Script funds FundMe — sender = script
        vm.prank(makeAddr("User"));
        fundFundMe.fundFundMe(address(fundMe));

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 contractBalance = address(fundMe).balance;

        // --- Act ---

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        vm.deal(address(withdrawFundMe), 1 ether);

        vm.prank(fundMe.getOwner());
        withdrawFundMe.withdrawFundMe(address(fundMe));

        // --- Assert ---

        uint256 endingOwnerBalance = fundMe.getOwner().balance;

        assertEq(address(fundMe).balance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + contractBalance);
    }
}
