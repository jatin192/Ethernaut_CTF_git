// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Hack} from "../../src/05_Telephone/Hack.sol";
import "forge-std/console.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public 
    {
        Hack hack;
        vm.startBroadcast();
        hack = new Hack();
        vm.stopBroadcast();
    }
}
