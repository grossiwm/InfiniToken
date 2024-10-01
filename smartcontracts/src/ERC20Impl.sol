// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "./tokens/ERC20.sol";

contract ERC20Impl is ERC20 {
    constructor(string memory _name, string memory _symbol, uint256 initialSupply)
        ERC20(_name, _symbol, initialSupply)
    {}
}
