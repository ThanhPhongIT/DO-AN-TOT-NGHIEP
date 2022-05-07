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
        // tên phải có độ dài > 0
        require(bytes(_name).length > 0);
        // Giá phải lớn hơn 0
        require(_price > 0);
        // tăng bộ đếm sản phẩm
        productCount ++;
        // Tạo sản phẩm
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        // Thực hiện sự kiện
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable {
        // lấy ra sản phẩm theo id
        Product memory _product = products[_id];
        // truy xuất chủ sở hữu
        address payable _seller = _product.owner;
        // đảm bảo id hợp lệ
        require(_product.id > 0 && _product.id <= productCount);
        // yêu cầu người mua phải có đủ eth
        require(msg.value >= _product.price);
        // yêu cầu sản phẩm chưa được bán
        require(!_product.purchased);
        // yêu cầu người mua không phải người bán
        require(_seller != msg.sender);
        // Chuyển người sở hữu thành người mua
        _product.owner = msg.sender;
        // đánh giấu sản phẩm đã được bán
        _product.purchased = true;
        // cập nhật sản phẩm
        products[_id] = _product;
        // thanh toán cho người bán bằng cách chuyển ether vào tài khoản của họ
        address(_seller).transfer(msg.value);
        // Thực hiện sự kiện
        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }
}
