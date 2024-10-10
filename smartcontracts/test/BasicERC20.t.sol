// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {BasicERC20} from "../src/BasicERC20.sol";
import {BaseSetup} from "./BaseSetup.t.sol";
import {Vm} from "forge-std/Vm.sol";
import "forge-std/console.sol";

contract BasicERC20Test is BaseSetup {
    function testName() public {
        assertEq(BASIC_ERC20_NAME, basicERC20.name());
    }

    function testSymbol() public {
        assertEq(BASIC_ERC20_SYMBOL, basicERC20.symbol());
    }

    function testTotalSupply() public {
        assertEq(BASIC_ERC20_INITIAL_SUPPLY * (10 ** uint256(basicERC20.decimals())), basicERC20.totalSupply());
    }

    function testBalanceOf() public {
        assertEq(basicERC20.totalSupply(), basicERC20.balanceOf(address(creator)));
    }

    function testTransferSuccess() public {
        uint256 currentCreatorBalance = basicERC20.balanceOf(creator);
        vm.prank(creator);
        basicERC20.transfer(alice, 100);
        assertEq(100, basicERC20.balanceOf(alice));
        assertEq(currentCreatorBalance - 100, basicERC20.balanceOf(creator));
    }

    function testTransferInsufficientBalance() public {
        vm.startPrank(bob);
        vm.expectRevert(bytes("Insufficient balance"));
        basicERC20.transfer(eve, 20);
        vm.stopPrank();
    }

    function testTransferFromSuccess() public {
        uint256 currentCreatorBalance = basicERC20.balanceOf(creator);
        uint256 currentAliceBalance = basicERC20.balanceOf(alice);
        uint256 currentBobBalance = basicERC20.balanceOf(bob);

        vm.prank(creator);
        basicERC20.approve(bob, 1000);
        vm.prank(bob);
        basicERC20.transferFrom(creator, alice, 1000);
        assertEq(currentCreatorBalance - 1000, basicERC20.balanceOf(creator));
        assertEq(currentAliceBalance + 1000, basicERC20.balanceOf(alice));
        assertEq(currentBobBalance, basicERC20.balanceOf(bob));
    }

    function testTransferFromApprovalLimitExceeded() public {
        vm.prank(creator);
        basicERC20.approve(bob, 1000);
        vm.startPrank(bob);
        vm.expectRevert(bytes("Approval limit exceeded"));
        basicERC20.transferFrom(creator, alice, 1001);
        vm.stopPrank();
    }

    function testTransferFromInsufficientBalance() public {
        vm.prank(trent);
        basicERC20.approve(bob, 1000);
        vm.startPrank(bob);
        vm.expectRevert(bytes("Insufficient balance"));
        basicERC20.transferFrom(trent, alice, 1000);
        vm.stopPrank();
    }
}
