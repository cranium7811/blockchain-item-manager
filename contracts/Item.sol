// SPDX-License-Identifier: MIT]
pragma solidity >0.7.0;

import "./ItemManager.sol";
import "./Ownable.sol";

contract Item {

    ItemManager parentContract;
    uint price;
    uint index;
    uint pricePaid;

    constructor(ItemManager _parentContract, uint _price, uint _index) {
        _parentContract = parentContract;
        _price = price;
        _index = index;
    }

    receive() external payable {
        require(pricePaid == 0, "You have already paid for the item");
        require(msg.value == price, "Only full payments allowed!");
        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "Payment not successful. Please try again.");
    }
}