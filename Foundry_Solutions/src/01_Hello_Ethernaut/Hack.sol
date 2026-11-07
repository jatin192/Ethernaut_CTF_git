// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Interface} from "./Interface.sol";
import "forge-std/console.sol";

contract Hack
{
    Interface public i;
    string public pass_;
    event Pass(string pass);
    constructor() 
    {
        i = Interface(address(0x9061293CDE09551b0f1aF5e09b49020a3856F260));
        pass_ = i.password();
        i.authenticate(pass_);
        emit Pass(pass_);
    } 
}










