// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


//  TOSBT.sol
contract TOSBT is ERC721URIStorage, ERC721Enumerable, Ownable, ERC721Burnable, ERC2771Context {
    uint256 private _tokenIdCounter;

    constructor(address forwarder) ERC721("TOSBT", "TOT") Ownable(msg.sender) ERC2771Context(forwarder) {}

    event SBTMinted(address recipient, uint256 tokenId);

    function mintSBT(address recipient, string memory tokenUrl) public onlyOwner{
        _tokenIdCounter += 1;
        uint256 newTokenId = _tokenIdCounter;
        _mint(recipient, newTokenId);
        _setTokenURI(newTokenId, string(abi.encodePacked(tokenUrl, "/", Strings.toString(newTokenId), ".json")));
        emit SBTMinted(recipient, newTokenId);
    }
    function transferFrom(address, address, uint256) public pure override(ERC721, IERC721) {
        revert("Transfer is not allowed for this token");
    }
    function safeTransferFrom(address, address, uint256, bytes memory) public pure override(ERC721, IERC721) {
        revert("Transfer is not allowed for this token");
    }
    function approve(address, uint256) public pure override(ERC721, IERC721) {
        revert("Approval is not allowed for this token");
    }
    function setApprovalForAll(address, bool) public pure override(ERC721, IERC721) {
        revert("Approval is not allowed for this token");
    }
    function _msgSender() internal view override(Context, ERC2771Context) returns (address) {
        return ERC2771Context._msgSender();
    }
    function _msgData() internal view override(Context, ERC2771Context) returns (bytes calldata) {
        return ERC2771Context._msgData();
    }
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return ERC721Enumerable._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        ERC721Enumerable._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return ERC721URIStorage.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
