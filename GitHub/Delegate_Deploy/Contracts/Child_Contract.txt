// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SimpleERC20 is ERC20 {
    address public admin;

    constructor(address _admin, uint256 initialSupply) ERC20("SimpleERC20", "SE20") {
        admin = _admin;
        _mint(msg.sender, initialSupply);
    }
}
