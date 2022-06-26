// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract PromNeur is ERC721, Ownable {
    uint256 public mintPrice; //dont use these willynilly, we want to minimize the creation of variable creation and change to keep cost low
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled; //toggle true or false
    string internal baseTokenUri; // if we use a market place(openSea), this is the url it can use to locate our NFT
    address payable public withdrawWallet; //this is how you would withdraw from a maxPerWallet
    mapping(address => uint256) public walletMints; //this will determine & keep track ofall the mints done


    constructor() payable ERC721( 'PromNeur', 'PN'){
        mintPrice = 0 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
        //Set withdraw wallet address
    } //this constructor function is the one that would be called first when a contract is created/initialized

    function setIsPublicMintEnabled(bool isPublicMintEnabled_) external onlyOwner{
     //this function allows only the owner of the contract to be able to call this function  
     isPublicMintEnabled = isPublicMintEnabled_;
     }

     function setBaseTokenUri(string calldata baseTokenUri_) external onlyOwner{
        baseTokenUri = baseTokenUri_;
        //  uri that contains the address of the images 
     }

     function tokenURI(uint256 tokenId_) public view override returns (string memory){
        // function that opens the market place (open sea) to grab the images
        // by default tokeURI is a function that exists in ERC721
        require(_exists(tokenId_), 'Token does not exist!');
        return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenId_), ".json"));

     }

     function withdraw() external onlyOwner{
        (bool success, ) = withdrawWallet.call{ value: address(this).balance }('');
        require(success, 'withdraw failed');
     } 

     //mint function

     function mint(uint256 quantity_) public payable {
        //most imp part of the NFT contract

        require(isPublicMintEnabled, 'minting not enabled');
        require(msg.value == quantity_ * mintPrice, 'wrong mint value');
        require(totalSupply + quantity_ <= maxSupply, 'sold out');
        require(walletMints[msg.sender] + quantity_ <= maxPerWallet, 'exceeding maximum wallet limit');

        for (uint256 i=0; i< quantity_; i++){
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId); //inherited function from ERC721
            
        }
     }
    
}