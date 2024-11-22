// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleERC20.sol";

contract DelegateDeployFactory {

    // Event to log the deployed contract address
    event TokenDeployed(address tokenAddress, address admin, uint256 initialSupply);

    // Deploy a new SimpleERC20 token contract
    function deployToken(address admin, uint256 initialSupply) external returns (address) {
        // Deploy the SimpleERC20 contract using delegatecall
        SimpleERC20 token = new SimpleERC20(admin, initialSupply);
        emit TokenDeployed(address(token), admin, initialSupply);
        return address(token);
    }
}
