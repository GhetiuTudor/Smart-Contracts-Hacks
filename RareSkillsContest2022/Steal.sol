//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract Steal {
    address private owner;

    constructor() payable {
        require(msg.value == 1 ether);
        owner = msg.sender;
    }

    function steal(address delegate, bytes memory args) external {
        (bool sent,) = delegate.delegatecall(args);
        require(sent, "call failed");
        require(address(this).balance == 1 ether, "no");
    }

    function withdraw() external {
        require(msg.sender == owner, "only owner");
        payable(msg.sender).transfer(address(this).balance);
    }
}
