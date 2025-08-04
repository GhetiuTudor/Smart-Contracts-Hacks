//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

contract EtherStore {
    mapping(address => uint256) public balances;
    bool internal locked;

    constructor() payable{}


    //this modifier blocks reentrancy attacks by blocking
    //new calls to the withdraw fct until the entire logic is executed
    //it uses a bool - sets the bool on true when the execution starts 
    //and sets it on false only after the execution ended 
    //and blocks any call as long as the bool is true
    modifier noReentrancy {
        require(!locked, "the fct is locked");
        locked = true;
        _;
        locked = false;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public noReentrancy{
        uint256 bal = balances[msg.sender];
        require(bal > 0);

        (bool sent,) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }


}
