// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "./HederaTokenService.sol";
import "./HederaResponseCodes.sol";


contract HTSS is HederaTokenService {

    function tokenAssociate(address tokenAddress) external {
        int response = HederaTokenService.associateToken(msg.sender, tokenAddress);

        if (response != HederaResponseCodes.SUCCESS) {
            revert ("Associate Failed");
        }
    }
}
