// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol";
import "./CreateNft.sol";


interface INftFactory {
    function createNFTContract(
        address _initialOwner
    ) external returns (CreateNft newNft_, uint length_);

    function mint(
        address to,
        string memory uri
    ) external returns (uint tokenId);
}

contract SocialMedia {

    address public nftFactoryContract;
    uint256 postCount;
    uint256 public tokenIdCounter;
    uint256 groupCount;
    address groupAdmin;

    //user authentication
    struct Identity{
        string username;
    }
    
    //Posts
    struct Post {
        uint256 postId;
        string tokenUri;
        string postContent;
        address owner;
        uint256 likes;
        string[] comments;
        uint256 timePosted;
    }

    Post[] allPosts;

    //Groups
    struct Group {
        address groupAdmin;
        string name;
        string description;
        address[] members;
    }
    Group[] allGroups;

    mapping(address => Identity) public identities;    
    mapping(address => bool) public signedIn;
    mapping(uint256 => address) posts;
    mapping(uint256 => mapping(address => bool)) public liked;
    mapping(uint256 => string) public Groups;


    event IdentityCreated(address indexed user, string username);
    event SignedIn(address indexed user);
    event PostCreated(string post, uint256 postId);
    event GroupCreated(string indexed name, uint256 members);
    event CommentPosted(string indexed comment, uint256 indexed postId);
    event PostLiked(address likedBy, uint256 postId);

    constructor(address _nftFactoryContract) {
        nftFactoryContract = _nftFactoryContract;    }



 

// register user
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
    function makePost(string memory _postContent, string memory _tokenUri) external {
        require(signedIn[msg.sender], "User not signed in");    

        uint256 _newId = INftFactory(nftFactoryContract).mint(msg.sender, _tokenUri);

        Post memory newPost = allPosts[_newId];
        newPost.postId = _newId;
        newPost.tokenUri = _tokenUri;
        newPost.postContent = _postContent;
        newPost.owner = msg.sender;
        newPost.likes = 0;       
        newPost.timePosted = block.timestamp;      

        postCount += 1;

        allPosts.push(newPost);
    }

//Like a post
    function likePost(uint256 _postId) external {
        require(signedIn[msg.sender], "User not signed in");
        require(!liked[_postId][msg.sender], "you liked this post already!");

        allPosts[_postId].likes++;

        emit PostLiked(msg.sender, _postId);

    }

//comment on posts
    function commentOnPost(uint _postId, string memory _comment) external {
        require(signedIn[msg.sender], "Please sign in to comment");        

        Post storage post = allPosts[_postId];
        post.comments.push(_comment);

        emit CommentPosted(_comment, _postId);

     } 

//create group/community
    function createGroup(string memory _name, string memory _description, address[] memory _members) external {
        require(msg.sender != address(0), "address zero detected");
        require(signedIn[msg.sender], "Sign in to create group"); 

        uint256 _groupId = groupCount + 1;

        require(bytes(allGroups[_groupId].name).length == 0, "Identity already exists");               

        Group storage newGroup = allGroups[_groupId];
        newGroup.groupAdmin = msg.sender;
        newGroup.name = _name;
        newGroup.description = _description;
        newGroup.members = _members;

        groupCount = groupCount + 1;
        
        allGroups.push(newGroup);
    }    

    //Join a group
    // function joinGroup(string memory _groupId) external {
    //     require(signedIn[msg.sender], "Sign in to join group");
    //     require(_groupId > 0 && _groupId <= groupCount, "Invalid group ID");
    // }

    // function acceptNewMembers() external onlyAdmin{}
 
    function searchPost(uint256 _postId) external  {}

    function refreshPage() external view returns (Post [] memory){
        return allPosts;
    }

}
    





//user authentication
//factory for NFT creation
//interactions(likes, search, comments)
//creation of groups/communities
//gassless transaction