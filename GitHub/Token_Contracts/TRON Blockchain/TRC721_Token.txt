// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BasicTRC721
 * @dev Implements the TRC721 standard for non-fungible tokens (NFTs) on the Tron blockchain.
 */
contract BasicTRC721 {
    // Token name
    string public name;

    // Token symbol
    string public symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private tokenOwners;

    // Mapping from owner address to token count
    mapping(address => uint256) private balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private tokenApprovals;

    // Event emitted when a token is transferred
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    // Event emitted when a token is approved
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Initializes the contract with a name and symbol for the token collection.
     * @param _name Name of the token collection.
     * @param _symbol Symbol of the token collection.
     */
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    /**
     * @dev Returns the balance of tokens owned by a specific address.
     * @param owner Address to query the balance for.
     * @return The number of tokens owned by the address.
     */
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "TRC721: balance query for the zero address");
        return balances[owner];
    }

    /**
     * @dev Returns the owner of a specific token ID.
     * @param tokenId Token ID to query the owner for.
     * @return The address of the owner.
     */
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = tokenOwners[tokenId];
        require(owner != address(0), "TRC721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev Transfers a token to another address.
     * @param from Address of the current token owner.
     * @param to Address of the recipient.
     * @param tokenId Token ID to transfer.
     */
    function transferFrom(address from, address to, uint256 tokenId) public {
        require(from == ownerOf(tokenId), "TRC721: transfer of token that is not owned");
        require(msg.sender == from || msg.sender == tokenApprovals[tokenId], "TRC721: caller is not owner nor approved");
        require(to != address(0), "TRC721: transfer to the zero address");

        // Clear approval
        tokenApprovals[tokenId] = address(0);

        // Update balances
        balances[from] -= 1;
        balances[to] += 1;

        // Transfer ownership
        tokenOwners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approves another address to transfer a specific token.
     * @param to Address to be approved.
     * @param tokenId Token ID to approve.
     */
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "TRC721: approval caller is not the token owner");

        tokenApprovals[tokenId] = to;

        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev Returns the approved address for a specific token ID.
     * @param tokenId Token ID to query the approved address for.
     * @return The address approved to transfer the token.
     */
    function getApproved(uint256 tokenId) public view returns (address) {
        require(tokenOwners[tokenId] != address(0), "TRC721: approved query for nonexistent token");
        return tokenApprovals[tokenId];
    }

    /**
     * @dev Mints a new token and assigns it to an address.
     * @param to Address to receive the token.
     * @param tokenId Token ID of the new token.
     */
    function mint(address to, uint256 tokenId) public {
        require(to != address(0), "TRC721: mint to the zero address");
        require(tokenOwners[tokenId] == address(0), "TRC721: token already minted");

        // Update balances and ownership
        balances[to] += 1;
        tokenOwners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }
}
