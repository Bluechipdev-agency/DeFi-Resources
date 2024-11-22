// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Greeting is Ownable {

    // State variable to store the greeting message
    string private greetingMessage;

    // Event to log when the greeting message is updated
    event GreetingUpdated(string newGreeting);

    // Constructor to set the initial greeting message
    constructor(string memory initialGreeting) {
        greetingMessage = initialGreeting;
    }

    // Function to set the greeting message (only callable by the owner)
    function setGreeting(string memory newGreeting) public onlyOwner {
        greetingMessage = newGreeting;
        emit GreetingUpdated(newGreeting);
    }

    // Function to read the current greeting message
    function getGreeting() public view returns (string memory) {
        return greetingMessage;
    }
}
