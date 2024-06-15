// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";


//  My39NFT.sol
contract TOSBT is ERC721URIStorage, Ownable, ERC2771Context {
    uint256 private _tokenIdCounter;

    constructor(address forwarder) ERC721("TOSBT", "TOT") Ownable(msg.sender) ERC2771Context(forwarder) {}

    function mintNFT(address recipient, string memory tokenUrl) public onlyOwner{
        _tokenIdCounter += 1;
        uint256 newTokenId = _tokenIdCounter;
        _mint(recipient, newTokenId);
        _setTokenURI(newTokenId, tokenUrl);
    }
    function transferFrom(address, address, uint256) public pure override(ERC721, IERC721) {
        revert("Transfer is not allowed for this token");
    }
    function safeTransferFrom(address, address, uint256, bytes memory) public pure override(ERC721, IERC721) {
        revert("Transfer is not allowed for this token");
    }
    function _msgSender() internal view override(Context, ERC2771Context) returns (address) {
        return ERC2771Context._msgSender();
    }
    function _msgData() internal view override(Context, ERC2771Context) returns (bytes calldata) {
        return ERC2771Context._msgData();
    }
    function _contextSuffixLength() internal view override(Context, ERC2771Context) returns (uint256) {
        return ERC2771Context._contextSuffixLength();
    }
}
