pragma solidity 0.5.1;


contract HashMarket {

    // Track the state of the items, while preserving history
    enum ItemStatus {
        active,
        sold,
        removed
    }

    struct Item {
        bytes32 name;
        uint price;
        address seller;
        ItemStatus status;
    }

    event ItemAdded(bytes32 name, uint price, address seller);
    event ItemPurchased(uint itemID, address buyer, address seller);
    event ItemRemoved(uint itemID);
    event FundsPulled(address owner, uint amount);

    Item[] private _items;
    mapping (address => uint) public _pendingWithdrawals;

    modifier onlyIfItemExists(uint itemID) {
        require(_items[itemID].seller != address(0));
        _;
    }

    function addNewItem(bytes32 name, uint price) public returns (uint) {

        _items.push(Item({
            name: name,
            price: price,
            seller: msg.sender,
            status: ItemStatus.active
        }));

        emit ItemAdded(name, price, msg.sender);
        // Item is pushed to the end, so the lenth is used for
        // the ID of the item
        return _items.length-1;
    }
    function getItem(uint itemID) public view onlyIfItemExists(itemID)
    returns (bytes32, uint, address, uint) {

        Item storage item = _items[itemID];
        return (item.name, item.price, item.seller, uint(item.status));
    }
    
}
