//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract XRC4907Storage {

    uint256 public tokenIdCounter;
    
    struct StudentDocs {
        string docType;
        string ipfsHash;
        uint256 expiresIn;
        uint256 tokenId;
        address user;
    }

    mapping(uint256 => StudentDocs) internal tokenIdToDocsMinted;
    mapping(address => uint256[4]) internal userToTokenIds;
    mapping(uint256 => bool) internal lockedStatus;

    error XRC4907Storage__TokenIdLocked();
}