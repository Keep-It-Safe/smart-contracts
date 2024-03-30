// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC4907.sol";
import "./XRC4907Storage.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract XRC4907 is ERC721, IERC4907, XRC4907Storage, ERC721URIStorage {

    constructor() ERC721("KeepItSafe", "KiS") {
        tokenIdCounter = 0;
    }

    /// @notice Set the user and expiration timestamp of an NFT
    /// @dev The zero address indicates there is no user
    /// Throws if `tokenId` is not a valid NFT
    /// @param tokenId The ID of the NFT
    /// @param _user The new user of the NFT
    /// @param expires The expiration timestamp for renting
    function setUser(
        uint256 tokenId,
        address _user,
        uint64 expires
    ) public virtual override {
        StudentDocs storage studentDoc = tokenIdToDocsMinted[tokenId];
        studentDoc.user = _user;
        studentDoc.expiresIn = expires;
    }

    /// @notice Get the user address of an NFT
    /// @param tokenId The ID of the NFT
    /// @return The user address for this NFT
    function userOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        if(tokenIdToDocsMinted[tokenId].expiresIn >= block.timestamp){
            return tokenIdToDocsMinted[tokenId].user;
        }
        else {
            return ownerOf(tokenId);
        }
    }

    /// @notice Get the expiration timestamp of an NFT
    /// @param tokenId The ID of the NFT
    /// @return The expiration timestamp for this NFT
    function userExpires(uint256 tokenId)
        public
        view
        virtual
        override
        returns (uint256)
    {
        if(tokenIdToDocsMinted[tokenId].expiresIn >= block.timestamp){
            return tokenIdToDocsMinted[tokenId].expiresIn;
        }
        else {
            return 115792089237316195423570985008687907853269984665640564039457584007913129639935;
        }
    }

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return
            interfaceId == type(IERC4907).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721URIStorage, ERC721)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function mint(address to, string memory _docType, string memory _ipfsHash, uint64 expiresIn) public {
        uint256 tokenId = tokenIdCounter;
        tokenIdCounter++;
        tokenIdToDocsMinted[tokenId] = StudentDocs(_docType, _ipfsHash, expiresIn, tokenId, to);
        userToTokenIds[to].push(tokenId);
        _mint(to, tokenId);
        if(expiresIn == 0){
            _setTokenURI(tokenId, _ipfsHash);
        }
    }
    
    function getStudentDocs(address student) public view returns(StudentDocs[] memory){
        uint256[] memory tokenIds = userToTokenIds[student];
        StudentDocs[] memory studentDocs = new StudentDocs[](tokenIds.length);
        for(uint256 i = 0; i < tokenIds.length; i++){
            studentDocs[i] = tokenIdToDocsMinted[tokenIds[i]];
        }
        return studentDocs;
    }

    function getStudentDocsCount(address student) public view returns(uint256){
        return userToTokenIds[student].length;
    }

    function getStudentDocById(uint256 tokenId) public view returns(StudentDocs memory){
        return tokenIdToDocsMinted[tokenId];
    }

}