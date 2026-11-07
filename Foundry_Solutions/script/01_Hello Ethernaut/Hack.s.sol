// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Hack} from "../../src/01_Hello_Ethernaut/Hack.sol";

contract CounterScript is Script {
    Hack public i;
    function setUp() public {}
    function run() public 
    {
        vm.startBroadcast();




        i = new Hack();




        
        vm.stopBroadcast();
    }
}
