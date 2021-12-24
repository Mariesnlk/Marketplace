// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import "./interfaces/IERC721Enumerable.sol";

contract ERC721Enumerable is ERC721, IERC721Enumerable {

    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    //mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokensIds;

    //mapping from token id index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^
        keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
    }

    // return a count of valid NFTs tracked by this contract, where each one of
    // them has an assigned and queryable owner not equal to the zero address
    // function totalSupply() external view returns (uint256) {
    //     return _allTokens.length;
    // }

    //return the token identifier for the `_index`th NFT and throws if `_index` >= `totalSupply()`
    //function tokenByIndex(uint256 _index) external view returns (uint256);

    //return the token identifier for the `_index`th NFT assigned to `_owner` and throws if `_index` >= `balanceOf(_owner)` or if
    // `_owner` is the zero address, representing invalid NFTs.
    //function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);

    //add tokens to the _allTokens array and set the position
    // of  the tokens indexes
    function _addTokensToEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address owner, uint256 tokenId) private {
        //add address and tokenId to the _ownedTokensIds
        //_ownedTokensIndex tokenId set to address of _ownedTokensIds
        _ownedTokensIndex[tokenId] = _ownedTokensIds[owner].length;
        _ownedTokensIds[owner].push(tokenId);

    }

    function totalSupply() public override view returns(uint256) {
        return _allTokens.length; 
    }

    function tokenByIndex(uint256 index) public override view returns(uint256) {
        require(index < totalSupply(), "ERC721Enumerable - index is out of bounds!");
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public override view returns(uint256) {
        require(index < balanceOf(owner), "ERC721Enumeration - owner index ia out of bounds!");
        return _ownedTokensIds[owner][index];
    }
 
    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        
        //add tokens to the owner
        //all tokens to totalSupply = to allTokens
        _addTokensToEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
        
    }

}