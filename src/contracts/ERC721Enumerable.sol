// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';

contract ERC721Enumerable is ERC721 {

    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    //mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokensIds;

    //mapping from token id index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

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

    function _addTokensToTotalSupply(uint256 tokenId) private {
        
        _allTokens.push(tokenId);
    }

    function totalSupply() public view returns(uint256) {
        return _allTokens.length; 
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        
        //add tokens yo the owner
        _addTokensToTotalSupply(tokenId);

        //all tokens to totalSupply = to allTokens
        

    }

}