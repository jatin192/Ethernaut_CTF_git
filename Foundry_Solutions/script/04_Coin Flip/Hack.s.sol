// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Hack} from "../../src/04_Coin Flip/Hack.sol";
import "forge-std/console.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public 
    {
        Hack hack;

        // Tx 1: deploy
        vm.startBroadcast();
        hack = new Hack();
        vm.stopBroadcast();

    

/*    
//  ______________________________________________________________________________________________________________________
    //⚠️ startBroadcast() does not mine a new block. It records calls as transactions to broadcast later *************
        
    ❌
    for (uint256 n = 0; n < 10; n++) 
        {
            console.log("block number", block.number);
            vm.startBroadcast();
            hack.attack();
            vm.stopBroadcast();
        }
    ______________________________________________________________________________________________________________________*/
    }
}
/*

set -a && source .env && set +a    \

for i in {1..10}; do
cast send 0xDeDA80149fde7a6bdD8532A56EcD4d691729805a "attack()" \
  --rpc-url sepolia \
  --private-key "$PRIVATE_KEY"
done

*/
