// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Connector.sol";

contract KryptoPaint is ERC721Connector {
    //array to store nfts
    string[] public kryptoPaintz;

    mapping(string => bool) _kryptoPaintzExists;

    function mint(string memory _kryptoPaint) public {

        require(!_kryptoPaintzExists[_kryptoPaint], 
        "Error: this paint already exists ");

        kryptoPaintz.push(_kryptoPaint);
        uint256 _id = kryptoPaintz.length - 1;
        _mint(msg.sender, _id);

        _kryptoPaintzExists[_kryptoPaint] = true;
    }

    constructor() ERC721Connector("KryptoPaint", "KPAINTZ") {}
}
