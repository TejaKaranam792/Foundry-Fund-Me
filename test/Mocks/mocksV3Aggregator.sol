// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AggregatorV3 {
    uint8 private _decimals;
    uint256 private _version = 4;

    int256 private _answer;
    uint256 private _startedAt;
    uint256 private _updatedAt;
    uint80 private _answeredInRound;

    constructor(uint8 decimals_, int256 initialAnswer) {
        _decimals = decimals_;
        _answer = initialAnswer;
        _startedAt = block.timestamp;
        _updatedAt = block.timestamp;
        _answeredInRound = 1;
    }

    function decimals() external view returns (uint8) {
        return _decimals;
    }

    function version() external view returns (uint256) {
        return _version;
    }

    function getRoundData(
        uint80 roundId
    )
        external
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        return (roundId, _answer, _startedAt, _updatedAt, _answeredInRound);
    }

    function latestRoundData()
        external
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        return (1, _answer, _startedAt, _updatedAt, _answeredInRound);
    }

    function updateAnswer(
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) external {
        _answer = answer;
        _startedAt = startedAt;
        _updatedAt = updatedAt;
        _answeredInRound = answeredInRound;
    }
}
