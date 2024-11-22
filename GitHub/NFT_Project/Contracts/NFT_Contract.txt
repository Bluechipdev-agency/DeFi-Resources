// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BasicNFT is ERC721URIStorage, Ownable {
    // Track token IDs
    uint256 private _tokenIdCounter;

    // Event for minting
    event TokenMinted(address recipient, uint256 tokenId, string tokenURI);

    // Constructor to set the name and symbol of the NFT collection
    constructor() ERC721("BasicNFT", "BNFT") {
        _tokenIdCounter = 1; // Starting token ID from 1
    }

    // Function to mint a new NFT
    function mint(address to, string memory tokenURI) public onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        
        emit TokenMinted(to, tokenId, tokenURI);

        // Increment the token ID counter for the next mint
        _tokenIdCounter++;
    }

    // Function to get the current token ID counter
    function currentTokenId() public view returns (uint256) {
        return _tokenIdCounter;
    }
}
