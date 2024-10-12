// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Counter} from "../src/Counter.sol";
import {BasicERC20} from "../src/BasicERC20.sol";
import {InfiniToken} from "../src/InfiniToken.sol";
import {Utils} from "./Utils.t.sol";

contract BaseSetup is Utils {
    string BASIC_ERC20_NAME = "Awesome Name";
    string BASIC_ERC20_SYMBOL = "AWME";
    uint8 BASIC_ERC20_DECIMALS = 18;
    uint256 BASIC_ERC20_INITIAL_SUPPLY = 1000000;

    string INFINITOKEN_NAME = "InfiniToken";
    string INFINITOKEN_SYMBOL = "IFT";
    uint8 INFINITOKEN_DECIMALS = 2;
    uint256 INFINITOKEN_CLAIM_AMOUNT = 100 * (10 ** INFINITOKEN_DECIMALS);
    uint256 INFINITOKEN_COOLDOWN_TIME = 24 hours;

    Counter counter;
    BasicERC20 basicERC20;
    InfiniToken infiniToken;

    address[] _users;
    address creator;
    address alice;
    address bob;
    address eve;
    address trent;
    address zero;

    function setUp() public virtual {
        _users = createUsers(5);

        creator = _users[0];
        alice = _users[1];
        bob = _users[2];
        eve = _users[3];
        trent = _users[4];
        zero = address(0x0);

        vm.label(creator, "CREATOR");
        vm.label(alice, "ALICE");
        vm.label(bob, "BOB");
        vm.label(eve, "EVE");
        vm.label(trent, "TRENT");
        vm.label(zero, "ZERO");

        vm.startPrank(creator);
        counter = new Counter();
        basicERC20 = new BasicERC20(BASIC_ERC20_NAME, BASIC_ERC20_SYMBOL, BASIC_ERC20_INITIAL_SUPPLY);
        infiniToken = new InfiniToken(
            INFINITOKEN_NAME,
            INFINITOKEN_SYMBOL,
            INFINITOKEN_DECIMALS,
            INFINITOKEN_CLAIM_AMOUNT,
            INFINITOKEN_COOLDOWN_TIME
        );
        vm.stopPrank();

        vm.warp(1438269988);
    }

    function test_basesetup_just_for_pass_in_converage() public {}
}
