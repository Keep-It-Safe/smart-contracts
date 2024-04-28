// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./IERC4907.sol";
import "./XRC4907Storage.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract XRC4907 is ERC721, IERC4907, XRC4907Storage, ERC721URIStorage {
    constructor() ERC721("KeepItSafe", "KiS") {
        tokenIdCounter = 1;
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
    function userOf(
        uint256 tokenId
    ) public view virtual override returns (address) {
        if (tokenIdToDocsMinted[tokenId].expiresIn >= block.timestamp) {
            return tokenIdToDocsMinted[tokenId].user;
        } else {
            return ownerOf(tokenId);
        }
    }

    /// @notice Get the expiration timestamp of an NFT
    /// @param tokenId The ID of the NFT
    /// @return The expiration timestamp for this NFT
    function userExpires(
        uint256 tokenId
    ) public view virtual override returns (uint256) {
        if (tokenIdToDocsMinted[tokenId].expiresIn >= block.timestamp) {
            return tokenIdToDocsMinted[tokenId].expiresIn;
        } else {
            return
                115792089237316195423570985008687907853269984665640564039457584007913129639935;
        }
    }

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, ERC721URIStorage) returns (bool) {
        return
            interfaceId == type(IERC4907).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function tokenURI(
        uint256 tokenId
    )
        public
        view
        virtual
        override(ERC721URIStorage, ERC721)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function mint(
        address _owner,
        address _to,
        string memory _docType,
        string memory _ipfsHash,
        uint64 _expiresIn
    ) public {
        uint256 tokenId = tokenIdCounter;
        tokenIdCounter++;
        tokenIdToDocsMinted[tokenId] = StudentDocs(
            _docType,
            _ipfsHash,
            _expiresIn,
            tokenId,
            _owner
        );
        if (_expiresIn == 0) {
            _mint(_to, tokenId);
            _setTokenURI(tokenId, _ipfsHash);
            lockedStatus[tokenId] = true;
            if (
                keccak256(abi.encodePacked(_docType)) ==
                keccak256(abi.encodePacked("lor"))
            ) {
                userToTokenIds[_owner][0] = tokenId;
            } else if (
                keccak256(abi.encodePacked(_docType)) ==
                keccak256(abi.encodePacked("gradesheet"))
            ) {
                userToTokenIds[_owner][1] = tokenId;
            } else if (
                keccak256(abi.encodePacked(_docType)) ==
                keccak256(abi.encodePacked("degree"))
            ) {
                userToTokenIds[_owner][2] = tokenId;
            }
        } else {
            _mint(_owner, tokenId);
            setUser(tokenId, _to, _expiresIn);
            if (
                keccak256(abi.encodePacked(_docType)) ==
                keccak256(abi.encodePacked("idcard"))
            ) {
                userToTokenIds[_to][3] = tokenId;
            }
        }
    }

    function burn(uint256 tokenId) public virtual override {
        
        _burn(tokenId);
        delete tokenIdToDocsMinted[tokenId];
        delete lockedStatus[tokenId];
        for (uint256 i = 0; i < 4; i++) {
            if (userToTokenIds[msg.sender][i] == tokenId) {
                delete userToTokenIds[msg.sender][i];
                break;
            }
        }
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override(IERC721, ERC721) {
        if (lockedStatus[tokenId] == true) {
            revert XRC4907Storage__TokenIdLocked();
        }
        super.safeTransferFrom(from, to, tokenId);
    }

    function getStudentDocById(
        uint256 _tokenId
    ) public view returns (StudentDocs memory) {
        return tokenIdToDocsMinted[_tokenId];
    }

    function time() public view returns (uint256) {
        return block.timestamp;
    }

    function hasDocExpired(address _student) public returns (bool) {
        uint256 tokenId = userToTokenIds[_student][3];
        if (userOf(tokenId) == _student) {
            userToTokenIds[_student][3] = 0;
            return true;
        }
        return false;
    }

    function getDocsForAStudent(
        address _student
    ) public view returns (StudentDocs[] memory) {
        StudentDocs[] memory studentDoc = new StudentDocs[](4);
        uint256 index = 0;
        for (uint256 i = 0; i < 4; i++) {
            if (userToTokenIds[_student][i] != 0) {
                studentDoc[index] = tokenIdToDocsMinted[
                    userToTokenIds[_student][i]
                ];
                index++;
            }
        }
        return studentDoc;
    }
}
