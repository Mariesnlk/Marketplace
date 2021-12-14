// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Kryptobird{

    string private _name;
    string private _symbol;

    constructor() {

        _name = 'Kryptobirdz';
        _symbol = 'KBIRDZ';
    }

    function name() public view returns(string memory) {
        return _name;
    }

    function symbol() public view returns(string memory) {
        return _symbol;
    }

}    



