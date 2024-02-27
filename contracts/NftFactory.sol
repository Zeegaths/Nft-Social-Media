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
        address _initialOwner
    ) external returns (CreateNft newNft_, uint length_) {
        newNft_ = new CreateNft(_initialOwner);

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