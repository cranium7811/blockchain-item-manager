// SPDX-License-Identifier: MIT]
pragma solidity >0.7.0;

contract Ownable {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(isOwner(), "You are not the owner.");
        _;
    }

    function isOwner() public view returns(bool) {
        return(msg.sender == owner);
    }
}