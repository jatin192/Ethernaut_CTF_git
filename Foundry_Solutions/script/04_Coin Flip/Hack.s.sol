// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Hack} from "../../src/04_Coin Flip/Hack.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public 
    {
        Hack hack;

        // Tx 1: deploy
        vm.startBroadcast();
        hack = new Hack();
        vm.stopBroadcast();

    // ______________________________________________________________________________________________________________________
    // startBroadcast() does not mine a new block. It records calls as transactions to broadcast later *************
        
    
        // for (uint256 n = 0; n < 10; n++) 
        // {

        //     vm.startBroadcast();
        //     hack.attack();
        //     vm.stopBroadcast();
        // }
    // ______________________________________________________________________________________________________________________
    }
}
