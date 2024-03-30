// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC4907.sol";

contract XRC4907 is ERC721, IERC4907 {

    uint256 tokenIdCounter;

    struct StudentDocs {
        string docType;
        string ipfsHash;
        uint256 expiresIn;
        uint256 tokenId;
    }

    mapping(address => StudentDocs[]) public studentDocs;

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
        
    }

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return
            interfaceId == type(IERC4907).interfaceId ||
            super.supportsInterface(interfaceId);
    }

}