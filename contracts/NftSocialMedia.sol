// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol";


contract NftSocialMedia is GSNRecipient {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;

    address payable owner;

    struct MarketItem {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }
    
    mapping(uint256 => MarketItem) private idMarketItem;

    event idMarketItemCreated(uint256 indexed tokenId,
        address payable seller,
        address payable owner,
        uint256 price,
        bool sold);

    modifier OnlyOwner() { require(msg.sender == owner, "only the owner can change the price");
    _;
        
    }

    constructor() ERC721 ("NFT Social Media Token", "NSM") {
        owner == payable(msg.sender);
    }

    //accept all gas fee requests
    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    ) external view returns (uint256, bytes memory) {
        return _approveRelayedCall();
    }
    
    function _preRelayedCall(bytes memory context) internal returns (bytes32) {
    }

    function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal {
    }


    function createToken(string memory tokenURI, uint256 price) public payable returns(uint256) {
        _tokenIds.increment();

        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId);

        _setTokenURI(newTokenId, tokenURI);

        createMarketItem(newTokenId, price);

        function createMarketItem(uint256 tokenId, uint256 price) private {
            require(price > 0, "Price must be at least 1");

            idMarketItem[tokenId] = MarketItem(
                tokenId,
                payable(msg.sender),
                payable(address(this)),
                price,
                false
            );
            _transfer(msg.sender, address(this), tokenId);

            emit idMarketItemCreated(tokenId, msg.sender, address(this), price, false)
        }

        function resellToken(uint256 tokenId, uint256 price) public payable {
            require (idToMarketItem[tokenId].owner == msg.sender, "Only Item owner can perfom the sale"); 

            idMarketItem[tokenId].sold = false;
            idMarketItem[tokenId].price = price;
            idMarketItem[tokenId].seller = payable(msg.sender);
            idMarketItem[tokenId].owner = payable(address(this));

            _itemsSold.decrement();
            
            _transfer(msg.sender, address(this), tokenId);
        }

        function sellItem(uint256 tokenId) public payable {
            uint price = idMarketItem[tokenId].price;

            require(
                msg.value == price, "insufficient balance"
            );

            // idMarketItem[tokenId].seller = payable(msg.sender);
            idMarketItem[tokenId].sold = true;
            idMarketItem[tokenId].owner = payable(address(0));

            _itemsSold.increment();

            _transfer(address(this), msg.sender, tokenId);

            payable(idMarketItem[tokenId].seller).transfer(msg.value)        
        }

        function fetchMarketItem() public view returns

    }






}
