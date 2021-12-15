// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*

minting function:
1. nft to point to an address
2. keep track of the token ids
3. keep track of token owner addresses to token ids
4. keep track how many tokens an owner has
5. create an event that emints a transfer log  -
    contract address, where it is being minted to, the id

*/
contract ERC721 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    //mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    //mapping from owner to number of owned tokens
    mapping(address => uint256) private _numberOwnedTokens;

    function _exists(uint256 tokenId) internal view returns(bool) {
        //setting the address of nft owner to check the mapping of the address 
        //from tokenOwner to tokenId
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: the mint address cannot be 0");

        //require that the token has not already been minted
        require(!_exists(tokenId), "ERC721: token alredy minted");

        //who owns which token
        //add a new address with tokenId for minting
        _tokenOwner[tokenId] = to;
        _numberOwnedTokens[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }


}