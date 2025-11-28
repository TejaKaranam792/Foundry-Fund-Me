// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Correct Chainlink import (you can swap to local file if needed)
import {AggregatorV3Interface} from 
"chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import {PriceConverter} from "../src/PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    address public immutable iowner;
    uint256 public constant MINIMUM_USD = 5e18;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        iowner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "You need to spend more ETH!"
        );

        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        if (msg.sender != iowner) revert NotOwner();
        _;
    }

    function withdraw() public onlyOwner {
        uint256 len = funders.length;

        for (uint256 i = 0; i < len; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    // Your wrapper function preserved
    function AddressToAmountFunded(address funder) public view returns (uint256) {
        return addressToAmountFunded[funder];
    }

    function getFunder(uint256 index) public view returns (address) {
        return funders[index];
    }

    function getOwner() public view returns (address) {
        return iowner;
    }
}
