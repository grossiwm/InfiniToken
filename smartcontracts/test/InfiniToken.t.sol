// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../src/InfiniToken.sol";
import {BaseSetup} from "./BaseSetup.t.sol";
import {console2} from "forge-std/console2.sol";

contract InfiniTokenTest is BaseSetup {

    function testInitialSupplyIsZero() public {
        assertEq(infiniToken.totalSupply(), 0);
    }

    function testUserCanClaimTokens() public {
        vm.prank(bob);
        infiniToken.claimTokens();

        vm.prank(eve);
        infiniToken.claimTokens();

        assertEq(infiniToken.balanceOf(bob), 100 * (10 ** uint256(infiniToken.decimals())));
        assertEq(infiniToken.balanceOf(eve), 100 * (10 ** uint256(infiniToken.decimals())));


        assertEq(infiniToken.totalSupply(), 200 * (10 ** uint256(infiniToken.decimals())));
    }

    function testClaimTokensOncePerDay() public {
        
        vm.startPrank(bob);
        infiniToken.claimTokens();
        vm.expectRevert("You can only claim once every 24 hours");
        infiniToken.claimTokens();

        vm.stopPrank();

    }

    function testCanClaimAgainAfter24Hours() public {
        vm.prank(bob);
        infiniToken.claimTokens();

        vm.warp(block.timestamp + 24 hours);

        vm.prank(bob);
        infiniToken.claimTokens();

        assertEq(infiniToken.balanceOf(bob), 200 * (10 ** uint256(infiniToken.decimals())));
    }

    function testMultipleUsersCanClaim() public {
        vm.prank(bob);
        infiniToken.claimTokens();
        vm.prank(alice);
        infiniToken.claimTokens();

        assertEq(infiniToken.balanceOf(bob), 100 * (10 ** uint256(infiniToken.decimals())));
        assertEq(infiniToken.balanceOf(alice), 100 * (10 ** uint256(infiniToken.decimals())));

        assertEq(infiniToken.totalSupply(), 200 * (10 ** uint256(infiniToken.decimals())));
    }
}
