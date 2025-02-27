// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DoRacle} from "../src/DoRacle.sol";
import {DoRacleToken} from "../src/DoRacleToken.sol";

contract Deploy is Script {
    DoRacleToken public token;
    DoRacle public protocol;

    function init() internal {  
    }

    function run() public {
        init();
        vm.startBroadcast();

        token = new DoRacleToken();
        protocol = new DoRacle(address(token));
        token.setProtocol(address(protocol));

        console.log("Creator (owner): ", msg.sender);
        console.log("DoRacleToken: ", address(token));
        console.log("DoRacle: ", address(protocol));

        vm.stopBroadcast();
    }
}
