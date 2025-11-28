// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    /**
     * @notice Returns ETH/USD price with 18 decimals
     */
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();

        // ---- Safety fix: ensure Chainlink did NOT return a negative price ----
        require(answer > 0, "Invalid price");

        // ---- Your original logic preserved ----
        // Chainlink returns 8 decimals → convert to 18 decimals
        // uint256(answer * 1e10)
        return uint256(uint256(answer) * 1e10);
    }

    /**
     * @notice Converts a given ETH amount to USD using Chainlink feed
     */
    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);

        // ---- Your original logic preserved ----
        // (ethPrice * ethAmount) / 1e18
        return (ethPrice * ethAmount) / 1e18;
    }
}
