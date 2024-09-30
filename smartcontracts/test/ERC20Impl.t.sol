// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20Impl} from "../src/ERC20Impl.sol";
import {BaseSetup} from "./BaseSetup.t.sol";
import {Vm} from "forge-std/Vm.sol";
import "forge-std/console.sol";

contract ERC20ImplTest is BaseSetup {
    function testName() public {
        assertEq(DEFAULT_NAME, token.name());
    }

    function testSymbol() public {
        assertEq(DEFAULT_SYMBOL, token.symbol());
    }

    function testTotalSupply() public {
        assertEq(DEFAULT_INITIAL_SUPPLY * (10 ** uint256(token.decimals())), token.totalSupply());
    }

    function testBalanceOf() public {
        assertEq(token.totalSupply(), token.balanceOf(address(creator)));
    }

    function testTransferSuccess() public {
        uint256 currentCreatorBalance = token.balanceOf(creator);
        vm.prank(creator);
        token.transfer(alice, 100);
        assertEq(token.balanceOf(alice), 100);
        assertEq(token.balanceOf(creator), currentCreatorBalance - 100);
    }

    function testTransferInsufficientBalance() public {
        vm.startPrank(bob);
        vm.expectRevert(bytes("Insufficient balance"));
        token.transfer(eve, 20);
        vm.stopPrank();
    }

    function testTransferFromSuccess() public {
        uint256 currentCreatorBalance = token.balanceOf(creator);
        uint256 currentAliceBalance = token.balanceOf(alice);
        uint256 currentBobBalance = token.balanceOf(bob);

        vm.prank(creator);
        token.approve(bob, 1000);
        vm.prank(bob);
        token.transferFrom(creator, alice, 1000);
        assertEq(currentCreatorBalance - 1000, token.balanceOf(creator));
        assertEq(currentAliceBalance + 1000, token.balanceOf(alice));
        assertEq(currentBobBalance, token.balanceOf(bob));
    }

    function testTransferFromApprovalLimitExceeded() public {
        vm.prank(creator);
        token.approve(bob, 1000);
        vm.startPrank(bob);
        vm.expectRevert(bytes("Approval limit exceeded"));
        token.transferFrom(creator, alice, 1001);
        vm.stopPrank();
    }

    function testTransferFromInsufficientBalance() public {
        vm.prank(trent);
        token.approve(bob, 1000);
        vm.startPrank(bob);
        vm.expectRevert(bytes("Insufficient balance"));
        token.transferFrom(trent, alice, 1000);
        vm.stopPrank();
    }
}
