// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";
import {ERC20Impl} from "../src/ERC20Impl.sol";

contract ERC20ImplScript is Script {
    ERC20Impl public token;
    string NAME = "Awesome Name";
    string SYMBOL = "AWME";
    uint256 INITIAL_SUPPLY = 1000000;

    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        token = new ERC20Impl(NAME, SYMBOL, INITIAL_SUPPLY);
        console2.log("Token address: ", address(token));

        vm.stopBroadcast();
    }
}
