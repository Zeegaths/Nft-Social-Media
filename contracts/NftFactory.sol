// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CreateNft.sol";

contract NFTFactory {
    event NFTCreated(address indexed owner, address indexed nftContract);

    function createNFT(string memory name, string memory symbol) external {
        CreateNft newNFT = new CreateNft(name, symbol);
        newNFT.transferOwnership(msg.sender);
        emit NFTCreated(msg.sender, address(newNFT));
    }
}
