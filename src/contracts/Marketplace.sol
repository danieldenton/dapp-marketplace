pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

     event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );


    constructor() public {
        name = "Dapp University Marketplace";
    }

    function createProduct(string memory _name, uint _price) public {
        require(bytes(_name).length > 0);
        require(_price > 0);
        // Make sure params are correct
        // Increment
        productCount ++;
        //  Create the product
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        // Trigger an event
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable {
        // Fetch the product
        Product memory _product = products[_id];
        // Fetch the owner
        address payable _seller = _product.owner;
        // Make sure the product is valid
        // Purchase
        _product.owner = msg.sender;
        // Trigger an event
        _product.purchased = true;

        products[_id] = _product;

        address(_seller).transfer(msg.value);

        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }
}