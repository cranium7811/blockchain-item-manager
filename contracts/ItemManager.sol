// SPDX-License-Identifier: MIT]
pragma solidity >0.7.0;

import "./Item.sol";
import "./Ownable.sol";

contract ItemManager is Ownable{
    
    enum ItemState {Created, Paid, Delivered}
    
    event ItemStep(uint _itemIndex, uint _step, address _itemAddress);

    struct New_Item {
        Item _item;
        uint _itemPrice;
        string _serialNumber;
        ItemManager.ItemState _state;
    }

    mapping(uint => New_Item) public items;
    uint mappingIndex;
    
    function createItem(string memory _serialNumber, uint _itemPrice) public onlyOwner {
        items[mappingIndex]._item = new Item(this, _itemPrice, mappingIndex);
        items[mappingIndex]._serialNumber = _serialNumber;
        items[mappingIndex]._itemPrice = _itemPrice;
        items[mappingIndex]._state = ItemState.Created;
        emit ItemStep(mappingIndex, uint(items[mappingIndex]._state), address(items[mappingIndex]._item));
        mappingIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable {
        require(items[_itemIndex]._state == ItemState.Created, "You can continue with the payment!");
        require(msg.value == items[_itemIndex]._itemPrice, "The value does not match the price of the item!");
        items[_itemIndex]._state = ItemState.Paid;
        emit ItemStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }

    function triggerDelivery(uint _itemIndex) public onlyOwner {
        require(items[_itemIndex]._state == ItemState.Paid, "You have not paid for the item!");
        items[_itemIndex]._state = ItemState.Delivered;
        emit ItemStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }
}
