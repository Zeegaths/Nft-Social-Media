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
    uint256 postCount;
    uint256 public tokenIdCounter;

    //user authentication
    struct Identity{
        string username;
    }

    struct Post{
        uint256 postId;
        string postContent;
        address owner;
        bool[] liked;
        string[] comments;
        uint256 timePosted;

    }

    Post[] AllPosts;

    mapping(address => Identity) public identities;    
    mapping(address => bool) public signedIn;
    mapping(uint256 => mapping(owner => Post)) public posts;


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

//User signIn
    function signIn() public {
        
        require(!signedIn[msg.sender], "Already signed in");
       
        signedIn[msg.sender] = true;

        emit SignedIn(msg.sender);
    }

//Post function
    function makePost(string _postContent, _nftName, _nftSymbol ) public {
        require(signedIn[msg.sender], "User not signed in");

        nftFactoryContract.createNFT(_nftName, _nftSymbol);

        newId = postCount + 1;

        nftFactoryContract.createNFT("_nftName", "nftSymbol");

        Post memory newPost = posts[msg.sender][Post.postId];
        newPost.postId = newId;
        newPost.postContent = _postContent;
        newPost.owner = msg.sender;
        newPost.comments = 0;
        newPost.timePosted = block.timestamp;

        uint256 tokenId = tokenIdCounter;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, string(abi.encodePacked("https://api.example.com/posts/", tokenId.toString())));

        tokenIdCounter++;

        postCount += 1
    }

    function likePost(uint256 ) {}

    function commentonPost(){} 

    function createGroup() {}
    

}
    





//user authentication
//factory for NFT creation
//interactions(likes, search, comments)
//creation of groups/communities
//gassless transaction