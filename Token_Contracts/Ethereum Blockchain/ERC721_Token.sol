// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BasicERC721
 * @dev Implements the ERC721 standard for non-fungible tokens.
 */
contract BasicERC721 {
    // Token name
    string public name;

    // Token symbol
    string public symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private tokenOwners;

    // Mapping from owner address to count of owned tokens
    mapping(address => uint256) private ownerTokenCount;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private tokenApprovals;

    // Event emitted when a token is transferred
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    // Event emitted when a token is approved for transfer by another address
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Initializes the contract with a name and symbol.
     * @param _name Name of the token.
     * @param _symbol Symbol of the token.
     */
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    /**
     * @dev Returns the balance of tokens owned by an address.
     * @param owner Address to query.
     */
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return ownerTokenCount[owner];
    }

    /**
     * @dev Returns the owner of the specified token ID.
     * @param tokenId Token ID to query.
     */
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = tokenOwners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev Transfers a token to another address.
     * @param from Current owner of the token.
     * @param to Address to receive the token.
     * @param tokenId Token ID to transfer.
     */
    function transferFrom(address from, address to, uint256 tokenId) public {
        require(to != address(0), "ERC721: transfer to the zero address");
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not owned");
        require(
            msg.sender == from || msg.sender == tokenApprovals[tokenId],
            "ERC721: caller is not owner nor approved"
        );

        // Clear approval
        tokenApprovals[tokenId] = address(0);

        // Update balances
        ownerTokenCount[from] -= 1;
        ownerTokenCount[to] += 1;

        // Transfer ownership
        tokenOwners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approves another address to transfer the specified token ID.
     * @param to Address to be approved.
     * @param tokenId Token ID to approve.
     */
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "ERC721: approval caller is not the token owner");

        tokenApprovals[tokenId] = to;

        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev Returns the approved address for a specific token ID.
     * @param tokenId Token ID to query.
     */
    function getApproved(uint256 tokenId) public view returns (address) {
        require(tokenOwners[tokenId] != address(0), "ERC721: approved query for nonexistent token");
        return tokenApprovals[tokenId];
    }

    /**
     * @dev Mints a new token.
     * @param to Address to receive the token.
     * @param tokenId Token ID of the new token.
     */
    function mint(address to, uint256 tokenId) public {
        require(to != address(0), "ERC721: mint to the zero address");
        require(tokenOwners[tokenId] == address(0), "ERC721: token already minted");

        // Update ownership and balances
        tokenOwners[tokenId] = to;
        ownerTokenCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }
}
