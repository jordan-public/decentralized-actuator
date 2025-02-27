// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DoRacleToken} from "../src/DoRacleToken.sol";
import {DoRacle} from "../src/DoRacle.sol";

contract DoRacleTest is Test {
    DoRacleToken public token;
    DoRacle public protocol;

    function setUp() public {
        token = new DoRacleToken();
        protocol = new DoRacle(address(token));
    }

    function test_Nothing() public {
    }
}
