// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title BasicERC3643
 * @dev A regulated token implementation using the ERC3643 standard.
 */
contract BasicERC3643 is ERC20, Ownable {
    // Mapping to track KYC-approved addresses
    mapping(address => bool) private kycApproved;

    // Event to notify when an address's KYC status is updated
    event KYCApproval(address indexed user, bool approved);

    /**
     * @dev Constructor to initialize the token with name, symbol, and initial supply.
     * @param name Name of the token.
     * @param symbol Symbol of the token.
     * @param initialSupply Initial supply of the token (minted to the deployer).
     */
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        // Mint the initial supply to the contract deployer
        _mint(msg.sender, initialSupply * (10 ** decimals()));
    }

    /**
     * @dev Updates the KYC status of a user.
     * @param user Address of the user.
     * @param approved KYC approval status (true for approved, false for revoked).
     */
    function setKYCApproval(address user, bool approved) public onlyOwner {
        kycApproved[user] = approved;
        emit KYCApproval(user, approved);
    }

    /**
     * @dev Checks if a user is KYC-approved.
     * @param user Address to query.
     * @return True if the user is KYC-approved, false otherwise.
     */
    function isKYCApproved(address user) public view returns (bool) {
        return kycApproved[user];
    }

    /**
     * @dev Overrides the ERC20 transfer function to enforce KYC checks.
     * @param recipient Address of the recipient.
     * @param amount Amount of tokens to transfer.
     * @return True if the transfer succeeds.
     */
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(kycApproved[msg.sender], "ERC3643: Sender is not KYC-approved");
        require(kycApproved[recipient], "ERC3643: Recipient is not KYC-approved");
        return super.transfer(recipient, amount);
    }

    /**
     * @dev Overrides the ERC20 transferFrom function to enforce KYC checks.
     * @param sender Address of the sender.
     * @param recipient Address of the recipient.
     * @param amount Amount of tokens to transfer.
     * @return True if the transfer succeeds.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(kycApproved[sender], "ERC3643: Sender is not KYC-approved");
        require(kycApproved[recipient], "ERC3643: Recipient is not KYC-approved");
        return super.transferFrom(sender, recipient, amount);
    }
}
