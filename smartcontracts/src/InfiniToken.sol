// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "./tokens/ERC20.sol";
import {Ownable} from "./access/Ownable.sol";

contract InfiniToken is ERC20, Ownable {
    mapping(address => uint256) private lastClaimTime;
    uint256 public claimAmount;
    uint256 public cooldownTime;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _claimAmount,
        uint256 _cooldownTime
    ) ERC20(_name, _symbol, 0, _decimals) Ownable() {
        claimAmount = _claimAmount;
        cooldownTime = _cooldownTime;
    }

    function claimTokens() external {
        uint256 lastClaim = lastClaimTime[msg.sender];

        if (lastClaim != 0) {
            require(block.timestamp >= lastClaim + cooldownTime, "You can only claim after cooldown time");
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

    function changeCooldownTime(uint256 _cooldownTime) external onlyOwner {
        cooldownTime = _cooldownTime;
    }

    function changeClaimAmount(uint256 _claimAmount) external onlyOwner {
        claimAmount = _claimAmount;
    }
}
