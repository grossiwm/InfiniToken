// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";
import {InfiniToken} from "../src/InfiniToken.sol";

contract InfiniTokenScript is Script {
    InfiniToken public token;
    string NAME = "Infinity Token";
    string SYMBOL = "INFTY";
    uint8 DECIMALS = 2;
    uint256 COOLDOWN_TIME = 24 hours;
    uint256 CLAIM_AMOUNT = 100 * ( 10**DECIMALS );

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        token = new InfiniToken(NAME, SYMBOL, DECIMALS, CLAIM_AMOUNT, COOLDOWN_TIME);
        console2.log("Token address: ", address(token));

        vm.stopBroadcast();
    }
}
