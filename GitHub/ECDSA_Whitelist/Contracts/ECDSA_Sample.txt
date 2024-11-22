// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ECDSAWhitelist {

    // Mapping to track whether an address is whitelisted
    mapping(address => bool) public whitelistedAddresses;

    // Address of the signer (the authority who signs the whitelist message)
    address public signer;

    // Event to log when an address is added to the whitelist
    event AddressWhitelisted(address indexed user);

    // Constructor to set the signer address (the trusted address that will sign the whitelist messages)
    constructor(address _signer) {
        signer = _signer;
    }

    // Function to check if the address is whitelisted
    function isWhitelisted(address _user) public view returns (bool) {
        return whitelistedAddresses[_user];
    }

    // Function to add an address to the whitelist
    // This function will only be called by the owner of the contract or the signer
    function addToWhitelist(address _user, bytes memory _signature) external {
        // Construct the message to verify
        bytes32 message = prefixed(keccak256(abi.encodePacked(_user)));

        // Recover the signer's address from the signature
        address recoveredSigner = recoverSigner(message, _signature);

        // Ensure the recovered signer is the trusted signer
        require(recoveredSigner == signer, "Invalid signature");

        // Add the address to the whitelist
        whitelistedAddresses[_user] = true;

        emit AddressWhitelisted(_user);
    }

    // Internal function to add the Ethereum prefix to the message hash
    function prefixed(bytes32 _hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash));
    }

    // Internal function to recover the signer from the signature
    function recoverSigner(bytes32 _message, bytes memory _signature) internal pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_message, v, r, s);
    }

    // Internal function to split the signature into r, s, and v values
    function splitSignature(bytes memory _sig) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(_sig.length == 65, "invalid signature length");

        assembly {
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
    }
}
