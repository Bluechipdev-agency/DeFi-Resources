// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@opensea/operator-filter-registry/OperatorFilterer.sol";

contract MyNFT is ERC721, Ownable, OperatorFilterer {

    uint256 private _tokenIdCounter;
    
    // Constructor for ERC721 token and setting up the operator filter
    constructor() ERC721("MyNFT", "MNFT") {
        _tokenIdCounter = 1; // Start the tokenId counter from 1
        // Register the contract with the operator filter
        _registerForOperatorFiltering();
    }

    // Override the transfer function to check if the operator is allowed
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override {
        super._beforeTokenTransfer(from, to, tokenId);

        // Check that the operator (marketplace or external address) is allowed
        if (from != address(0)) { // Skip check on minting
            require(
                isOperatorAllowed(from, to),
                "Operator not allowed on OpenSea"
            );
        }
    }

    // Function to mint new NFTs
    function mint(address to) external onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _tokenIdCounter++;
    }

    // Function to add or remove an operator to/from the filter
    function setOperatorFilter(address operator, bool allowed) external onlyOwner {
        if (allowed) {
            _registerOperator(operator);
        } else {
            _unregisterOperator(operator);
        }
    }

    // Internal function to handle operator registration via the OpenSea operator filter registry
    function _registerForOperatorFiltering() internal {
        // This is to register the contract with OpenSea's operator filter registry
        _registerForOperatorFiltering(address(this));
    }
}
