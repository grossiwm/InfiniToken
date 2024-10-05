// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Counter} from "../src/Counter.sol";
import {ERC20Impl} from "../src/ERC20Impl.sol";
import {InfiniToken} from "../src/InfiniToken.sol";
import {Utils} from "./Utils.t.sol";

contract BaseSetup is Utils {
    string DEFAULT_NAME = "Awesome Name";
    string DEFAULT_SYMBOL = "AWME";
    uint8 DEFAULT_DECIMALS = 18;
    uint256 DEFAULT_INITIAL_SUPPLY = 1000000;

    Counter counter;
    ERC20Impl token;
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
        token = new ERC20Impl(DEFAULT_NAME, DEFAULT_SYMBOL, DEFAULT_INITIAL_SUPPLY);
        infiniToken = new InfiniToken("InfiniToken", "IFT", 2);
        vm.stopPrank();

        vm.warp(1438269988);
    }

    function test_basesetup_just_for_pass_in_converage() public {}
}
