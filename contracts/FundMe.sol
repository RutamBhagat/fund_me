// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import { PriceConverter } from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    // we are attaching library to all uint256 values, which includes msg.value
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;
    address public immutable i_owner;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // 1e18 = 1 ETH = 1000000000000000000 wei = 1 * 10^18 wei
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Funding amount must be at least 5 USD worth of ETH"); // in getConversionRate() function, msg.value is the first parameter, if there are more params in the function then specify them inside parenthesis
        // if there is not enough ETH, then the transaction will revert
        
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value; // if address didn't funded before, then default value of funding is 0 and current value is added to it
    }

    function withdraw() public onlyOwner {
        for(uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        
        funders = new address[](0); // empty array of length 0

        //// there are three ways to withdraw funds
        //// transfer
        //// msg.sender if of type address
        //// payable(msg.sender) is of type payable address
        // payable(msg.sender).transfer(address(this).balance); // this will automatically revert if the transfer fails

        //// send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance); // this will only revert if you write a require statement afterwards
        // require(sendSuccess, "Withdrawal failed");

        //// call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}(""); // this will only revert if you write a require statement afterwards
        require(callSuccess, "Withdrawal failed");
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Only i_owner can call this function");
        if(msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    // what happens if someone sends ETH to the contract without calling the fund() function?
    // receive()
    // fallback()

        // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}