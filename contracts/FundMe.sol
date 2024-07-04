// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract FundMe {
    function fund() public payable {
        uint256 minimumUSD = 5;
        
        // 1e18 = 1 ETH = 1000000000000000000 wei = 1 * 10^18 wei
        require(msg.value >= minimumUSD, "FundMe: Funding amount must be at least 1 ETH"); 
        // if there is not enough ETH, then the transaction will revert

    }
}