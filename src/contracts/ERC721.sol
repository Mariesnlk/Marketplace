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

    // return the number of NFTs owned by _owner
    function balanceOf(address _owner) public view returns(uint256) {
        require(_owner != address(0), "ERC721: the owner address cannot be 0");

        return _numberOwnedTokens[_owner];
    }

    // returns the address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view returns(address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "ERC721: the owner address cannot be 0");

        return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        //setting the address of nft owner to check the mapping of the address 
        //from tokenOwner to tokenId
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    // virtual need to override function in inheritance
    function _mint(address to, uint256 tokenId) internal virtual {
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