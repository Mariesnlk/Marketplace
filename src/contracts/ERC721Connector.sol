// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ./ - the same directory
import './ERC721Metadata.sol';
import './ERC721.sol';

contract ERC721Connector is ERC721Matadata, ERC721 {

    //carry the metadata into over

    constructor(string memory name, string memory symbol) ERC721Matadata(name, symbol) {
        
    }

}