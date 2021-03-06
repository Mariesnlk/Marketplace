// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";
import "./libraries/Counters.sol";

contract ERC721 is ERC165, IERC721 {
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    //mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    //mapping from owner to number of owned tokens
    mapping(address => Counters.Counter) private _numberOwnedTokens;

    //mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("transferFrom(bytes4)")
            )
        );
    }

    // return the number of NFTs owned by _owner
    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "ERC721: the owner address cannot be 0");

        //return _numberOwnedTokens[_owner];
        return _numberOwnedTokens[_owner].current();
    }

    // returns the address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "ERC721: the owner address cannot be 0");

        return owner;
    }

    function _exists(uint256 _tokenId) internal view returns (bool) {
        //setting the address of nft owner to check the mapping of the address
        //from tokenOwner to tokenId
        address owner = _tokenOwner[_tokenId];
        return owner != address(0);
    }

    // virtual need to override function in inheritance
    function _mint(address _to, uint256 _tokenId) internal virtual {
        require(_to != address(0), "ERC721: the mint address cannot be 0");

        //require that the token has not already been minted
        require(!_exists(_tokenId), "ERC721: token alredy minted");

        //who owns which token
        //add a new address with tokenId for minting
        _tokenOwner[_tokenId] = _to;
        // _numberOwnedTokens[_to] += 1;
        _numberOwnedTokens[_to].increment();

        emit Transfer(address(0), _to, _tokenId);
    }

    //require that the person approving is the owne
    //require we cant approve sending tokens of the owner to the owner
    //approving an address to a tokenId
    //update the map of the approval addresses
    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(owner != _to, "ERC721 - approval to current owner");
        require(
            msg.sender == owner,
            "ERC721 - current caller is not the owner of the token"
        );

        _tokenApprovals[_tokenId] = _to;

        emit Approval(owner, _to, _tokenId);
    }

    function isApprovedOrOwner(address _spender, uint256 _tokenId)
        internal
        view
        returns (bool)
    {
        require(_exists(_tokenId), "ERC721 - token does not exist");
        address owner = ownerOf(_tokenId);
        return (_spender == owner || getApproved(_tokenId) == _spender);
    }

    function isApprovedAddress(address _owner, uint256 _tokenId)
        public
        view
        returns (bool)
    {
        return isApprovedOrOwner(_owner, _tokenId);
    }

    //get the approved address for a single NFT
    // returns the approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 _tokenId) public view returns (address) {
        require(
            _exists(_tokenId),
            "ERC721 - approved query for nonexistent token"
        );
        return _tokenApprovals[_tokenId];
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        //require that the address receiving a token is not a zero address
        require(_to != address(0), "ERC721 - transfer to the zero address");
        //require that the address transfering the token actually owns the token
        require(
            ownerOf(_tokenId) == _from,
            "ERC721 - trying to transfer a token the address does not own!"
        );

        //add the token id to the address receiving the token
        _tokenOwner[_tokenId] = _to;

        //update the balance of the address _from token
        //_numberOwnedTokens[_from] -= 1;

        //update the balance of the address _to
        //_numberOwnedTokens[_to] += 1;

        _numberOwnedTokens[_from].decrement();
        _numberOwnedTokens[_to].increment();

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }
}
