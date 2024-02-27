// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol";
import "./NftFactory.sol";


contract SocialMedia is GSNRecipient {


    NftFactory public nftFactoryContract;

    //user authentication
    struct Identity{
        string username;
    }

    mapping(address => Identity) public identities;    
    mapping(address => bool) public signedIn;

    event IdentityCreated(address indexed user, string username);
    event SignedIn(address indexed user);

    constructor(NftFactory _nftFactoryContract) {
        nftFactoryContract = _nftFactoryContract;
    }


//gasless transactions implementation
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

//register user
    function registerUser(string memory _username) public {
        require(bytes(_username).length > 0, "Username cannot be empty");
        require(bytes(identities[msg.sender].username).length == 0, "Identity already exists");

        identities[msg.sender] = Identity({
            username: _username
        });

        emit IdentityCreated(msg.sender, _username);
    }


    

    function signIn() public {
        
        require(!signedIn[msg.sender], "Already signed in");
       
        signedIn[msg.sender] = true;

        emit SignedIn(msg.sender);
    }

    function makePost() {}

    

}
    





//user authentication
//factory for NFT creation
//interactions(likes, search, comments)
//creation of groups/communities
//gassless transaction