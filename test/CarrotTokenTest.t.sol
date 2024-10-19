// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployCarrotToken} from "../script/DeployCarrotToken.s.sol";
import {CarrotToken} from "../src/CarrotToken.sol";

contract CarrotTokenTest is Test {
    DeployCarrotToken public deployer;
    CarrotToken public ct;
    address user = makeAddr("user");

    address public to;
    uint256 public amount;

    function setUp() public {
        deployer = new DeployCarrotToken();
        ct = deployer.run();

        vm.prank(msg.sender);
        ct.transfer(user, 100);
    }

    function testOnlyOwnerCanPause() public {
        vm.prank(user);
        vm.expectRevert();
        ct.pause();
    }

    function testOnlyOwnerCanUnpause() public {
        vm.prank(user);
        vm.expectRevert();
        ct.unpause();
    }

    function testOnlyOwnerCanMint() public {
        vm.prank(user);
        vm.expectRevert();
        ct.mint(to, amount);
    }

    function testCannotMintWhenPaused() public {
        // testing the
        vm.prank(msg.sender);
        ct.pause();

        vm.expectRevert();
        vm.prank(msg.sender);
        ct.mint(address(this), 2);
    }

    function testRevertsIfMintedToTheAddressZero() public {
        vm.prank(msg.sender);
        vm.expectRevert(CarrotToken.CarrotToken__NotZeroAddress.selector);
        ct.mint(to, 5);
    }

    function testRevertsIfTheAmountIsLessThanZero() public {
        vm.prank(msg.sender);
        vm.expectRevert(CarrotToken.CarrotToken__MustBeMoreThanZero.selector);
        ct.mint(address(this), 0);
    }

    function testCannotBurnIftheAmountIsLessThanZero() public {
        vm.prank(user);
        vm.expectRevert(CarrotToken.CarrotToken__CannotBurn.selector);
        ct.burn(0);
    }

    function testCannotBurnWhenPaused() public {
        vm.prank(msg.sender);
        ct.pause();

        vm.expectRevert();
        vm.prank(user);
        ct.burn(5);
    }

    function testUserCanBurnTokens() public {
        vm.prank(user);
        ct.burn(5);
    }

    function testUserCanTransfer() public {
        vm.prank(user);
        ct.transfer(address(this), 50);
        assertEq(ct.balanceOf(user), 50);
    }

    function testCannotTransferWhenPaused() public {
        vm.prank(msg.sender);
        ct.pause();

        vm.expectRevert();
        vm.prank(user);
        ct.transfer(address(this), 50);
        assertEq(ct.balanceOf(user), 100);
    }

    function testUsersCanRecieveTokens() public {
        vm.prank(msg.sender);
        ct.approve(user, 50);

        vm.prank(user);
        ct.transferFrom(msg.sender, user, 50);
        assertEq(ct.balanceOf(user), 150);
    }

    function testCannotReceiveTokensWhenPaused() public {
        vm.prank(msg.sender);
        ct.pause();

        vm.prank(msg.sender);
        ct.approve(user, 50);

        vm.expectRevert();
        vm.prank(user);
        ct.transferFrom(msg.sender, user, 50);
        assertEq(ct.balanceOf(user), 100);
    }
}
