//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address User=makeAddr("user");

    modifier funded(){
        vm.startPrank(User);
        fundMe.fund{value: 10 ether}();
        vm.stopPrank();
        
        _;
    }

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(User, 10 ether); // Give User 10 ether
    }

    function testMinimumDollarsIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18, "Minimum USD should be 5e18");
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender, "Owner should be the test contract");
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        console.log("Price Feed Version: ", version);
        assertEq(version, 4, "Price Feed Version should be 4 on Sepolia");
    }

    function testFundFailWithoutEnoughEth() public {
        vm.expectRevert("You need to spend more ETH!");
        fundMe.fund{value: 1e10}(); // very small amount, guaranteed to revert
    }

    function testFundUpdatesAmountFundedDataStructure() public {
        vm.prank(User);
        fundMe.fund{value: 10 ether}();
        uint256 amountFunded = fundMe.addressToAmountFunded(User);
        assertEq(amountFunded, 10 ether, "Amount funded should be updated correctly");
    }

    function testFundAddsFunderToArray() public {
        vm.prank(User);
        fundMe.fund{value: 10 ether}();
        address funders = fundMe.getFunder(0);
        assertEq(funders, User, "Funder should be added to the funders array");
    }

    function testOnlyOwnerCanWithdraw() public funded {
      
        vm.prank(User);
        vm.expectRevert("NotOwner()");
        fundMe.withdraw(); // User tries to withdraw, should revert
    }


    function testWithDrawWithaSingleFunder() public funded {
        uint256 initialBalance = fundMe.getOwner().balance;
        uint256 contractBalance = address(fundMe).balance;
        

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
       
        

        uint finalBalance=fundMe.getOwner().balance;
        uint finalFundMeBalance=address(fundMe).balance;
        assertEq(finalFundMeBalance, 0, "FundMe contract balance should be zero");
        assertEq(finalBalance, initialBalance + contractBalance, "Owner should receive all funds");
    }

    function testWithDrawWithMultipleFunders() public funded {
        uint160 NoOfFunders=10;
        uint160 StartingFunderIndex=1;
        for(uint160 i=StartingFunderIndex; i < NoOfFunders;i++){
           hoax(address(i),10 ether);
           fundMe.fund{value:10 ether}();
        }

        uint initialBalance = fundMe.getOwner().balance;
        uint contractBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assertEq(address(fundMe).balance, 0, "FundMe contract balance should be zero after withdrawal");
        assertEq(fundMe.getOwner().balance, initialBalance + contractBalance, "Owner should receive all funds after withdrawal");
    }

  

}
