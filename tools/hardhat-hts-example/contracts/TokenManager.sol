// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function mint(address account, uint256 amount) external returns (bool);
}

contract TokenManager {
    mapping(address => mapping(address => bool)) private tokenAssociations;
    mapping(address => uint64) private totalSupply;

    event TokenAssociated(address indexed account, address indexed token);
    event TokenDissociated(address indexed account, address indexed token);
    event TokensTransferred(address indexed token, address indexed from, address[] to, int64[] amounts, int responseCode);
    event TokensMinted(address indexed token, address indexed to, uint64 amount, bytes[] metadata, int responseCode, uint64 newTotalSupply, int64[] serialNumbers);

    function transferTokens(address token, address[] memory accountIds, int64[] memory amounts) external returns (int responseCode) {
        require(accountIds.length == amounts.length, "Mismatched input lengths");

        IERC20 tokenContract = IERC20(token);
        for (uint256 i = 0; i < accountIds.length; i++) {
            address recipient = accountIds[i];
            int64 amount = amounts[i];
            require(tokenAssociations[recipient][token], "Recipient not associated with token");

            require(tokenContract.transferFrom(msg.sender, recipient, uint256(int256(amount))), "Transfer failed");
        }

        emit TokensTransferred(token, msg.sender, accountIds, amounts, 0);
        return 0; // Success
    }

    function associateToken(address account, address token) external returns (int responseCode) {
        tokenAssociations[account][token] = true;
        emit TokenAssociated(account, token);
        return 0; // Success
    }

    function dissociateToken(address account, address token) external returns (int responseCode) {
        tokenAssociations[account][token] = false;
        emit TokenDissociated(account, token);
        return 0; // Success
    }

    function mintToken(address token, uint64 amount, bytes[] memory metadata) external returns (int responseCode, uint64 newTotalSupply, int64[] memory serialNumbers) {
        IERC20 tokenContract = IERC20(token);
        require(tokenContract.mint(msg.sender, uint256(amount)), "Minting failed");

        totalSupply[token] += amount;
        newTotalSupply = totalSupply[token];
        serialNumbers = new int64[](amount);
        for (uint64 i = 0; i < amount; i++) {
            serialNumbers[i] = int64(i + 1); // Serial numbers starting from 1
        }

        emit TokensMinted(token, msg.sender, amount, metadata, 0, newTotalSupply, serialNumbers);
        return (0, newTotalSupply, serialNumbers); // Success
    }
}
