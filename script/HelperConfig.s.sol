//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

import {AggregatorV3} from "../test/Mocks/mocksV3Aggregator.sol";

contract HelperConfig is Script {
  Config public activeConfig;
  uint8 public constant DECIMALS = 8;
  // 2000 USD in 8 decimals

    struct Config {
        address priceFeed;
    }

    constructor(){
        if (block.chainid == 11155111) { // Sepolia
            activeConfig = getSepoliaConfig();
        } else if (block.chainid == 31337) { // Anvil
            activeConfig = getAnvilConfig();
        } else {
            revert("Unsupported chain ID");
        }
    }
    function getSepoliaConfig()public pure returns(Config memory){
        Config memory config= Config({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Sepolia ETH/USD Price Feed
        });
        return config;
        
    }

    function getAnvilConfig()public returns(Config memory){
        if(activeConfig.priceFeed != address(0)) {
            return activeConfig; // Return cached config if it exists
        }

        vm.startBroadcast();
        AggregatorV3 priceFeed = new AggregatorV3(DECIMALS,2000e8); // 2000 USD in 8 decimals
        vm.stopBroadcast();
        Config memory config = Config({
            priceFeed: address(priceFeed)
        });
        return config;

    }
}