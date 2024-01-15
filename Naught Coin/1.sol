// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

 interface NaughtCoin 
 {
    function timeLock() external view returns (uint);
    function INITIAL_SUPPLY() external view returns (uint256);
    function player() external view returns (address);


      //  Constructor cannot be defined in interfaces.
     //   Functions in interfaces cannot have modifiers.


    //ERC20 funtions (imported)
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);  
 }