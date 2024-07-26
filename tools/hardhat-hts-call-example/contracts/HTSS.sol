// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "./HederaTokenService.sol";
import "./HederaResponseCodes.sol";


contract HTSS is HederaTokenService {

    function tokenAssociate(address tokenAddress) external {
        HederaTokenService.associateToken(msg.sender, tokenAddress);
    }
}
