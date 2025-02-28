// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DoRacleToken} from "../src/DoRacleToken.sol";
import {DoRacle} from "../src/DoRacle.sol";
import {TAction} from "../src/types/TAction.sol";

contract DoRacleTest is Test {
    DoRacleToken public token;
    DoRacle public protocol;

    address constant OWNER = 0x823eF872d97f3Cffd1e3D491c9560EB0D3886D56;
    address constant REQUESTER = 0x6A2B7bC980C5841Da8228C14b7EA0db464e8f583;
    address constant EXECUTOR = 0x64E8b276D11a7f93A76E435e6040353c05AF426A;
    address constant DISPUTER = 0x8d49F9187c29b5D6F511658fFdBBADeFD92B7376;
    address constant VOTER1 = 0x6aa333F3833D5AE966672CF1bBFdAbAD3fA20A0f;
    address constant VOTER2 = 0x605E1E9EB58547Ff88598C4079D7B477c79cB546;
    address constant VOTER3 = 0xdA9c29211C50013CFfb277626d03B05297778921;

    uint256 constant REWARD = 100 ether;
    uint256 constant GUARANTEE = 10 ether;

    function setUp() public {
        token = new DoRacleToken();
        protocol = new DoRacle(address(token));
        token.setProtocol(address(protocol));

        token.mint(REWARD);
        token.transfer(REQUESTER, REWARD);
        
        token.mint(GUARANTEE);
        token.transfer(EXECUTOR, GUARANTEE);

        token.mint(GUARANTEE);
        token.transfer(DISPUTER, GUARANTEE);

        token.mint(3 * protocol.VOTE_REWARD());
        token.transfer(VOTER1, protocol.VOTE_REWARD());
        token.transfer(VOTER2, protocol.VOTE_REWARD());
        token.transfer(VOTER3, protocol.VOTE_REWARD());
    }

    function test_Nothing() public {
    }

    function test_ExecuteAction() public {
        // Run as requester
        vm.startPrank(REQUESTER, REQUESTER);
        token.approve(address(protocol), REWARD);
        protocol.requestAction("Test", REWARD, GUARANTEE, block.timestamp + 100 /*seconds*/, block.timestamp + 200 , block.timestamp + 300);

        TAction memory action = protocol.getAction(0);
        assertEq(action.reward, REWARD);
        assertEq(action.guarantee, GUARANTEE);
        assertEq(action.requester, REQUESTER);

        // Run as executor
        vm.startPrank(EXECUTOR, EXECUTOR);
        token.approve(address(protocol), GUARANTEE);
        protocol.takeAction(0);
        protocol.executeAction(0);

        vm.warp(block.timestamp + 400);
        // No one disputed
        protocol.settleAction(0);
        assertEq(token.balanceOf(EXECUTOR), GUARANTEE + REWARD);
    }

    function test_NotTakenNotDisputedAction() public {
        // Run as requester
        vm.startPrank(REQUESTER, REQUESTER);
        token.approve(address(protocol), REWARD);
        protocol.requestAction("Test", REWARD, GUARANTEE, block.timestamp + 100 /*seconds*/, block.timestamp + 200 , block.timestamp + 300);

        TAction memory action = protocol.getAction(0);
        assertEq(action.reward, REWARD);
        assertEq(action.guarantee, GUARANTEE);
        assertEq(action.requester, REQUESTER);

        vm.warp(block.timestamp + 500);

        // No one took or disputed
        protocol.settleAction(0);
        assertEq(token.balanceOf(REQUESTER), REWARD);
    }

    function test_NotExecutedNotDisputedAction() public {
        // Run as requester
        vm.startPrank(REQUESTER, REQUESTER);
        token.approve(address(protocol), REWARD);
        protocol.requestAction("Test", REWARD, GUARANTEE, block.timestamp + 100 /*seconds*/, block.timestamp + 200 , block.timestamp + 300);

        TAction memory action = protocol.getAction(0);
        assertEq(action.reward, REWARD);
        assertEq(action.guarantee, GUARANTEE);
        assertEq(action.requester, REQUESTER);

        // Run as executor
        vm.startPrank(EXECUTOR, EXECUTOR);
        token.approve(address(protocol), GUARANTEE);
        protocol.takeAction(0);

        vm.warp(block.timestamp + 500);

        // No one disputed
        protocol.settleAction(0);
        assertEq(token.balanceOf(REQUESTER), GUARANTEE + REWARD);
    }

    function test_NotExecutedDisputedAction() public {
        // Run as requester
        vm.startPrank(REQUESTER, REQUESTER);
        token.approve(address(protocol), REWARD);
        protocol.requestAction("Test", REWARD, GUARANTEE, block.timestamp + 100 /*seconds*/, block.timestamp + 200 , block.timestamp + 300);

        TAction memory action = protocol.getAction(0);
        assertEq(action.reward, REWARD);
        assertEq(action.guarantee, GUARANTEE);
        assertEq(action.requester, REQUESTER);

        // Run as executor
        vm.startPrank(EXECUTOR, EXECUTOR);
        token.approve(address(protocol), GUARANTEE);
        protocol.takeAction(0);

        vm.warp(block.timestamp + 100);

        // Run as disputer
        vm.startPrank(DISPUTER, DISPUTER);
        token.approve(address(protocol), GUARANTEE);
        protocol.disputeAction(0);

        vm.warp(block.timestamp + 100);

        // Run as voter1
        vm.startPrank(VOTER1, VOTER1);
        token.approve(address(protocol), protocol.VOTE_REWARD());
        protocol.vote(0, true);

        // Run as voter2
        vm.startPrank(VOTER2, VOTER2);
        token.approve(address(protocol), protocol.VOTE_REWARD());
        protocol.vote(0, false);

        // Run as voter3
        vm.startPrank(VOTER3, VOTER3);
        token.approve(address(protocol), protocol.VOTE_REWARD());
        protocol.vote(0, false);

        vm.warp(block.timestamp + 100);

        // Voted as not executed
        protocol.settleAction(0);
        assertEq(token.balanceOf(REQUESTER), REWARD);
        assertEq(token.balanceOf(DISPUTER), 2 * GUARANTEE);
    }
}
