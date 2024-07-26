// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

interface IExternalContract {
    function associateToken(address account, address token) external returns (int responseCode);
}

contract HTS {
    address externalContractAddress = 0x0000000000000000000000000000000000000167;
    address tokenAddress = 0x0000000000000000000000000000000000468331;

    function tokenAssociate() external returns (int responseCode) {
        IExternalContract externalContract = IExternalContract(externalContractAddress);
        responseCode = externalContract.associateToken(msg.sender, tokenAddress);
        return responseCode;
    }
}