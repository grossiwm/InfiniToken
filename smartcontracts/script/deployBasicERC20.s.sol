// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";
import {BasicERC20} from "../src/BasicERC20.sol";

contract BasicERC20Script is Script {
    BasicERC20 public token;
    string NAME = "Awesome Name";
    string SYMBOL = "AWME";
    uint256 INITIAL_SUPPLY = 1000000;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        token = new BasicERC20(NAME, SYMBOL, INITIAL_SUPPLY);

        vm.stopBroadcast();
    }
}
