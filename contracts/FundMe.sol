// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import { PriceConverter } from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 minimumUSD = 5e18;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {
        // 1e18 = 1 ETH = 1000000000000000000 wei = 1 * 10^18 wei
        require(msg.value.getConversionRate() >= minimumUSD, "Funding amount must be at least 5 USD worth of ETH"); 
        // if there is not enough ETH, then the transaction will revert
        
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value; // if address didn't funded before, then default value of funding is 0 and current value is added to it
    }
}