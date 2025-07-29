// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0; //old vulnerable version 

contract VulnerableStaking {
    mapping(address => uint256) public balances;

    constructor() payable{}

    function stake() public payable{
        balances[msg.sender] += msg.value;
    }

    //...
    //Any necessary logic 
    //...

    // Vulnerable withdraw function 
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        //Sends Ether before updating state
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Transfer failed");
        balances[msg.sender] -= amount;
    }

    receive() external payable {}
}
