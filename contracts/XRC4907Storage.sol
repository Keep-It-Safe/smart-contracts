//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract XRC4907Storage {

    uint256 tokenIdCounter;
    
    struct StudentDocs {
        string docType;
        string ipfsHash;
        uint256 expiresIn;
        uint256 tokenId;
        address user;
    }

    mapping(uint256 => StudentDocs) public tokenIdToDocsMinted;
    mapping(address => uint256[]) public userToTokenIds;
}

