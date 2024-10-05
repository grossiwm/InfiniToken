// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../src/InfiniToken.sol";
import {BaseSetup} from "./BaseSetup.t.sol";
import {console2} from "forge-std/console2.sol";

contract InfiniTokenTest is BaseSetup {
    function testInitialSupplyIsZero() public {
        assertEq(0, infiniToken.totalSupply());
    }

    function testUserCanClaimTokens() public {
        vm.prank(bob);
        infiniToken.claimTokens();

        assertEq(INFINITOKEN_CLAIM_AMOUNT, infiniToken.balanceOf(bob));

        assertEq(INFINITOKEN_CLAIM_AMOUNT, infiniToken.totalSupply());
    }

    function testShouldRevertIfClaimBeforeCooldown() public {
        vm.startPrank(bob);
        infiniToken.claimTokens();
        vm.expectRevert("You can only claim after cooldown time");
        infiniToken.claimTokens();

        vm.stopPrank();
    }

    function testCanClaimAgainAfterColldownTime() public {
        vm.prank(bob);
        infiniToken.claimTokens();

        vm.warp(block.timestamp + INFINITOKEN_COOLDOWN_TIME);

        vm.prank(bob);
        infiniToken.claimTokens();

        assertEq(2 * INFINITOKEN_CLAIM_AMOUNT, infiniToken.balanceOf(bob));
    }

    function testMultipleUsersCanClaim() public {
        vm.prank(bob);
        infiniToken.claimTokens();

        vm.prank(eve);
        infiniToken.claimTokens();

        vm.prank(alice);
        infiniToken.claimTokens();

        assertEq(INFINITOKEN_CLAIM_AMOUNT, infiniToken.balanceOf(bob));
        assertEq(INFINITOKEN_CLAIM_AMOUNT, infiniToken.balanceOf(eve));
        assertEq(INFINITOKEN_CLAIM_AMOUNT, infiniToken.balanceOf(alice));

        assertEq(3 * INFINITOKEN_CLAIM_AMOUNT, infiniToken.totalSupply());
    }

    function testOwnerCanTransferOwnership() public {
        vm.prank(creator);
        infiniToken.transferOwnership(bob);

        assertEq(bob, infiniToken.owner());
    }

    function testNotOwnerCantTransferOwnership() public {
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(bob);
        infiniToken.transferOwnership(alice);
    }

    function testOwnerCanChangeCooldownTime() public {
        vm.prank(creator);
        infiniToken.changeCooldownTime(2 hours);

        assertEq(2 hours, infiniToken.cooldownTime());
    }

    function testOwnerCanChangeClaimAmount() public {
        vm.prank(creator);
        infiniToken.changeClaimAmount(500 * (10 ** INFINITOKEN_DECIMALS));

        assertEq(500 * (10 ** INFINITOKEN_DECIMALS), infiniToken.claimAmount());
    }

    function testShoulNotAllowNoOwnerChangeCooldownTime() public {
        
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(bob);
        infiniToken.changeCooldownTime(48 hours);
    }

    function testShoulNotAllowNoOwnerChangeClaimAmount() public {
        
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(bob);
        infiniToken.changeClaimAmount(500 * (10 ** INFINITOKEN_DECIMALS));
    }
    
}
