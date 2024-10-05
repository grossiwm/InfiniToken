// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "./tokens/ERC20.sol";

contract InfiniToken is ERC20 {
    mapping(address => uint256) private lastClaimTime;
    uint256 public claimAmount;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) ERC20(_name, _symbol, 0, _decimals) {
        claimAmount = 100 * (10 ** uint256(decimals));
    }

    function claimTokens() external {
        uint256 lastClaim = lastClaimTime[msg.sender];

        if (lastClaim != 0) {
            require(block.timestamp >= lastClaim + 24 hours, "You can only claim once every 24 hours");
        }

        _mint(msg.sender, claimAmount);
        lastClaimTime[msg.sender] = block.timestamp;
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "Invalid address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }
}
