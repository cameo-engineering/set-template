// SPDX-License-Identifier: ISC
pragma solidity 0.8.13;

import "forge-std/Test.sol";

import "./../Greeter.sol";

contract GreeterTest is Test {
    string public constant HELLO_WORLD_EN = "Hello, world!";
    string public constant HELLO_WORLD_RU = unicode"Привет, мир!";

    Greeter public greeter;

    event GreetingChanged(string greeting, string newGreeting);

    function setUp() external {
        greeter = new Greeter(HELLO_WORLD_EN);
    }

    function testChangeGreeting(string memory newGreeting) external {
        string memory greeting = greeter.greet();
        bool isEmptyGreeting = bytes(newGreeting).length == 0;
        bool isSameGreeting = keccak256(bytes(newGreeting)) == keccak256(bytes(greeting));

        if (isEmptyGreeting) {
            vm.expectRevert(abi.encodeWithSelector(GreeterZeroLengthGreeting.selector));
        } else if (isSameGreeting) {
            vm.expectRevert(abi.encodeWithSelector(GreeterGreetingDoesntChange.selector));
        } else {
            vm.expectEmit(false, false, false, true);
            emit GreetingChanged(greeting, newGreeting);
        }
        greeter.setGreeting(newGreeting);
        if (!isEmptyGreeting && !isSameGreeting) {
            assertEq(greeter.greet(), newGreeting);
        }
    }
}
