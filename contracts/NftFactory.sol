// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./CreateNft.sol";

interface ICreateNft {
    function safeMint(
        address to,
        string memory uri
    ) external returns (uint tokenId);
}

contract NftFactory {
    CreateNft[] NftClones;

    mapping(address => address) public userContract;

    function createNFTContract(
        string memory name,
        string memory symbol
            ) external returns (CreateNft newNft_, uint length_) {
        newNft_ = new CreateNft(name, symbol);

        userContract[msg.sender] = address(newNft_);

        NftClones.push(newNft_);

        length_ = NftClones.length;
    }

    function getUserContracts() public view returns (CreateNft[] memory) {
        return NftClones;
    }

    function mint(
        address to,
        string memory uri
    ) external returns (uint tokenId) {
        tokenId = ICreateNft(userContract[msg.sender]).safeMint(to, uri);
    }
}