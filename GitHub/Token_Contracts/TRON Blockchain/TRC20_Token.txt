// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Basic TRC20 Token
 * @dev Implements the TRC20 standard for tokens on the Tron blockchain.
 */
contract BasicTRC20 {
    // State variables
    string public name; // Token name
    string public symbol; // Token symbol
    uint8 public decimals; // Number of decimals for token values
    uint256 public totalSupply; // Total token supply

    // Mapping to store balances of accounts
    mapping(address => uint256) private balances;

    // Mapping for allowances (approval mechanism)
    mapping(address => mapping(address => uint256)) private allowances;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value); // Emitted when tokens are transferred
    event Approval(address indexed owner, address indexed spender, uint256 value); // Emitted when an allowance is approved

    /**
     * @dev Constructor to set initial values.
     * @param _name Name of the token.
     * @param _symbol Symbol of the token.
     * @param _decimals Number of decimal places.
     * @param _totalSupply Total token supply.
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply * (10 ** uint256(decimals));
        balances[msg.sender] = totalSupply; // Assign all tokens to the contract deployer
        emit Transfer(address(0), msg.sender, totalSupply); // Emit initial transfer event
    }

    /**
     * @dev Returns the balance of a specific address.
     * @param account The address to query.
     */
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    /**
     * @dev Transfers tokens to a specified address.
     * @param recipient The address to transfer to.
     * @param amount The amount to transfer.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Transfer to zero address"); // Prevent sending to the zero address
        require(balances[msg.sender] >= amount, "Insufficient balance"); // Check sender's balance

        balances[msg.sender] -= amount; // Deduct from sender
        balances[recipient] += amount; // Add to recipient

        emit Transfer(msg.sender, recipient, amount); // Emit transfer event
        return true;
    }

    /**
     * @dev Approves another address to spend tokens on behalf of the caller.
     * @param spender The address authorized to spend.
     * @param amount The amount to be spent.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "Approve to zero address"); // Prevent approving zero address

        allowances[msg.sender][spender] = amount; // Set allowance

        emit Approval(msg.sender, spender, amount); // Emit approval event
        return true;
    }

    /**
     * @dev Returns the amount that an owner allowed a spender to spend.
     * @param owner The address of the token owner.
     * @param spender The address authorized to spend.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    /**
     * @dev Transfers tokens on behalf of the owner.
     * @param sender The address from which tokens will be sent.
     * @param recipient The address to receive the tokens.
     * @param amount The amount of tokens to transfer.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        require(sender != address(0), "Transfer from zero address"); // Prevent zero address as sender
        require(recipient != address(0), "Transfer to zero address"); // Prevent zero address as recipient
        require(balances[sender] >= amount, "Insufficient balance"); // Check sender's balance
        require(allowances[sender][msg.sender] >= amount, "Allowance exceeded"); // Check allowance

        balances[sender] -= amount; // Deduct from sender
        balances[recipient] += amount; // Add to recipient
        allowances[sender][msg.sender] -= amount; // Update allowance

        emit Transfer(sender, recipient, amount); // Emit transfer event
        return true;
    }
}
