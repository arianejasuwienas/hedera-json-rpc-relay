//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract SampleContract {
    event Notification(string message);

    constructor() {
        emit Notification("Hello world!");
    }

    function revertableFunction() public {
        assert(false, "Reason");
    }
}
