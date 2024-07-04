// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
// Why is this a library and not abstract?
// Why not an interface?
library PriceConverter {
    // We could make this public, but then we'd have to deploy it
    function getPrice() internal view returns (uint256) {
        // Sepolia ETH / USD Address
        // https://docs.chain.link/data-feeds/price-feeds/addresses
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        uint256 constant DECIMALS = priceFeed.decimals();
        // ETH/USD rate in 18 digit
        // 10^18 is the number of wei in 1 ETH
        return uint256(answer) * 10**(18 - DECIMALS);
    }

    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        // remember that our ethAmount is in wei
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // (since our ethAmount is in wei and also our ethPrice has 18 decimal places)
        // the actual ETH/USD conversion rate, after adjusting the extra 0s.
        // Since solidity doesnt have support for decimal numbers, we need 18 decimal integers to get the actual conversion rate, keep this in mind 
        return ethAmountInUsd;
    }
}