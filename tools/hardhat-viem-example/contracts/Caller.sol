// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

interface IGreeter {
    function setGreeting(string memory _greeting) external;
}

contract Caller {
    address private greeterAddress = 0xAd0F1f0381642843b1d7a52447423c177B2228f6;
    IGreeter private greeter = IGreeter(greeterAddress);

    event GreetingUpdated(string newGreeting);

    function updateGreeting(string memory newGreeting) public {
        greeter.setGreeting(newGreeting);
        emit GreetingUpdated(newGreeting);
    }
}
