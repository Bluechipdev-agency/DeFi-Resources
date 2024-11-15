// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {

    string public name = "MyToken";         // Name of the token
    string public symbol = "MTK";           // Symbol of the token
    uint8 public decimals = 18;             // Number of decimal places
    uint256 public totalSupply;             // Total supply of tokens

    mapping(address => uint256) public balanceOf;         // Mapping from address to balance
    mapping(address => mapping(address => uint256)) public allowance; // Mapping for allowances

    event Transfer(address indexed from, address indexed to, uint256 value);  // Transfer event
    event Approval(address indexed owner, address indexed spender, uint256 value); // Approval event

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * (10 ** uint256(decimals));  // Set the initial supply with decimals
        balanceOf[msg.sender] = totalSupply;  // Assign the total supply to the contract deployer
    }

    // Transfer tokens from the sender to the recipient
    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(balanceOf[msg.sender] >= amount, "ERC20: insufficient balance");

        balanceOf[msg.sender] -= amount;  // Subtract from the sender's balance
        balanceOf[to] += amount;          // Add to the recipient's balance

        emit Transfer(msg.sender, to, amount);  // Emit transfer event
        return true;
    }

    // Allow a spender to withdraw from your account multiple times, up to the specified amount.
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address");

        allowance[msg.sender][spender] = amount;  // Set the allowance
        emit Approval(msg.sender, spender, amount);  // Emit approval event
        return true;
    }

    // Transfer tokens on behalf of another address, within the allowed limit
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(balanceOf[from] >= amount, "ERC20: insufficient balance");
        require(allowance[from][msg.sender] >= amount, "ERC20: allowance exceeded");

        balanceOf[from] -= amount;  // Subtract from the sender's balance
        balanceOf[to] += amount;    // Add to the recipient's balance
        allowance[from][msg.sender] -= amount;  // Reduce the spender's allowance

        emit Transfer(from, to, amount);  // Emit transfer event
        return true;
    }

    // Returns the amount of tokens an owner allowed to a spender
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowance[owner][spender];
    }
}
