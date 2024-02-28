// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract CreateNft is ERC721URIStorage, Ownable {
    using Strings for uint256;

    uint256 public tokenIdCounter;    


   constructor(        
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) Ownable() {
        
    }
    function safeMint(
        address to,
        string memory uri
    ) external returns (uint tokenId) {
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
