// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CreateNft is ERC721, Ownable {
    using Strings for uint256;

    uint256 public tokenIdCounter;
        

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        
    }

    function mintNFT() external onlyOwner {        
        uint256 newItemId = tokenIdCounter;
        _safeMint(msg.sender, newItemId);
        tokenIdCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");

        string memory baseURI = "https://api.example.com/metadata/";
        return string(abi.encodePacked(baseURI, tokenId.toString()));
    }
}
