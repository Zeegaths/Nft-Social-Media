// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract CreateNft is ERC721URIStorage, Ownable {
    using Strings for uint256;

    uint256 public tokenIdCounter;    


    constructor(
        address initialOwner
    ) ERC721("NFTS", "NFT") Ownable() {}

    function mintNFT() external onlyOwner {        
        uint256 newItemId = tokenIdCounter;
        _safeMint(msg.sender, newItemId);
        tokenIdCounter++;
    }

    function safeMint(
        address to,
        string memory uri
    ) external onlyOwner returns (uint tokenId) {
        tokenId = tokenIdCounter++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}
