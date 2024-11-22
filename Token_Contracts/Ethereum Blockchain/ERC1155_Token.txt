// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title BasicERC1155
 * @dev Implements the ERC1155 standard for multi-token support.
 */
contract BasicERC1155 is ERC1155, Ownable {
    // Mapping to store the total supply of each token type
    mapping(uint256 => uint256) private totalSupply;

    /**
     * @dev Constructor that initializes the contract with a base URI for metadata.
     * @param uri Base URI for token metadata.
     */
    constructor(string memory uri) ERC1155(uri) {}

    /**
     * @dev Mints a specified amount of a token type to an address.
     * @param account Address to receive the tokens.
     * @param id Token ID to mint.
     * @param amount Amount of tokens to mint.
     * @param data Additional data (optional).
     */
    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        require(account != address(0), "ERC1155: mint to the zero address");

        // Mint tokens and update total supply
        _mint(account, id, amount, data);
        totalSupply[id] += amount;
    }

    /**
     * @dev Mints a batch of tokens to an address.
     * @param account Address to receive the tokens.
     * @param ids Array of token IDs to mint.
     * @param amounts Array of amounts of tokens to mint for each ID.
     * @param data Additional data (optional).
     */
    function mintBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        require(account != address(0), "ERC1155: mint to the zero address");

        // Mint batch of tokens and update total supply
        _mintBatch(account, ids, amounts, data);
        for (uint256 i = 0; i < ids.length; i++) {
            totalSupply[ids[i]] += amounts[i];
        }
    }

    /**
     * @dev Returns the total supply of a specific token ID.
     * @param id Token ID to query.
     * @return Total supply of the token ID.
     */
    function totalSupplyOf(uint256 id) public view returns (uint256) {
        return totalSupply[id];
    }

    /**
     * @dev Burns a specified amount of a token type from an address.
     * @param account Address holding the tokens.
     * @param id Token ID to burn.
     * @param amount Amount of tokens to burn.
     */
    function burn(
        address account,
        uint256 id,
        uint256 amount
    ) public {
        require(
            account == msg.sender || isApprovedForAll(account, msg.sender),
            "ERC1155: caller is not owner nor approved"
        );

        // Burn tokens and update total supply
        _burn(account, id, amount);
        totalSupply[id] -= amount;
    }

    /**
     * @dev Burns a batch of token types from an address.
     * @param account Address holding the tokens.
     * @param ids Array of token IDs to burn.
     * @param amounts Array of amounts of tokens to burn for each ID.
     */
    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory amounts
    ) public {
        require(
            account == msg.sender || isApprovedForAll(account, msg.sender),
            "ERC1155: caller is not owner nor approved"
        );

        // Burn batch of tokens and update total supply
        _burnBatch(account, ids, amounts);
        for (uint256 i = 0; i < ids.length; i++) {
            totalSupply[ids[i]] -= amounts[i];
        }
    }
}
