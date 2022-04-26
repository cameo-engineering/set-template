// SPDX-License-Identifier: ISC
pragma solidity 0.8.13;

/// @dev Thrown when trying to set the greeting with zero length.
error GreeterZeroLengthGreeting();
/// @dev Thrown when new greeting is the same as previous.
error GreeterGreetingDoesntChange();

/// @title Simple greeter smart contract
/// @author Andrey Gulitsky <agulitsky@cameo.engineering>
/// @custom:security-contact security@cameo.engineering
contract Greeter {
    string private greeting;

    /// @dev Emitted when the greeting is changed.
    /// @param greeting Previous greeting.
    /// @param newGreeting New greeting.
    event GreetingChanged(string greeting, string newGreeting);

    constructor(string memory _greeting) {
        greeting = _greeting;
        emit GreetingChanged("", _greeting);
    }

    /// @dev Sets the new greeting.
    /// @param newGreeting New greeting.
    function setGreeting(string calldata newGreeting) external {
        if (bytes(newGreeting).length == 0) {
            revert GreeterZeroLengthGreeting();
        }
        if (keccak256(bytes(newGreeting)) == keccak256(bytes(greeting))) {
            revert GreeterGreetingDoesntChange();
        }

        emit GreetingChanged(greeting, newGreeting);
        greeting = newGreeting;
    }

    /// @dev Get current greeting.
    /// @return Current greeting.
    function greet() external view returns (string memory) {
        return greeting;
    }
}
