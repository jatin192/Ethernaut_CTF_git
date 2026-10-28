//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IHack 
{
    function whatIsTheMeaningOfLife() external view returns(uint);
}


// deploye -> Factory contract -> run deploy contract -> check output "adr": "0x3aD18EC437c396539C439CD1A4721B01F2800b1A"
// AtAddress (in remix) : put adr  to deploy IHack

/*
  Runtime code
  Creation code
  Factory contract


_________________________________________________________________________________________________________________________


Goal -> craft sequence of opcode so that it will return 32 bytes from memory & inside this memory we'll store 43 Number

______________________________________________opcodes__________________________________________________________________________
   
    opcode mstore(p,v)
                  -> take 2 inputs from the stack 
                                            _____  
                                            | p |  top
                                            | v |
                                            |___|
                                            stack

                  -> store v at memory p to p+32


    opcode RETURN 
                  -> return(p,s) - end execution & return data from memory p to p +s


    opcode PUSH
        1 bytes = 2 Hexadecimal
        PUSH1 0x11
        PUSH2 0x1122
        PUSH3 0x1122aa
        PUSHn -> n bytesSSS


________________________________________Runtime code___________________________________________________________________


step1
-> crafting opcode for storing 42(data) from memory 0 to 32

    PUSH1 0x2a      v
    PUSH1 0x00      p
    MSTORE          store v at memory p to p+32  ===  store 43 at memory 0 to 0+32


step2
->  crafting opcode for returning data from memory 0 to 32

    PUSH1 0x20       s= 32
    PUSH1 0x00       p= 0
    RETURN           return data from memory p to p +s  ===   0 to 0+32   == first 32 bytes


step 3
calculating bytecode
Given : The opcode for PUSH1  is 0x60
        The opcode for MSTORE is 0x52
        The opcode for RETURN is 0xf3

bytecode   0x60 + 0x2a   +   0x60 + 0x00  +  MSTORE  +  0x60 + 0x20  +  0x60 + 0x00  +  RETURN
           ___________       ___________     ______     ___________     ___________     ______

bytcode = 0x602a60005260206000f3




**********************************
Runtiime code - return 42        *      
0x602a60005260206000f3           *
**********************************



________________________________________creation code_________________________________________________


store run timme code to memory

PUSH10 0x602a60005260206000f3      v == 42
PUSH1  0x00                        p
MSTORE                             mstore(p,v) store v at memory p to p+32 bytes memory   == 0 to 32 bytes memory

we store this but we want data from 22 to 32th memory bytes 
0x    000000000000000000000000000000000000000000   602a60005260206000f3
__    __________________________________________   ____________________
2                        42                                 20


PUSH1  0x0a                         s = 10  = 20/2                       
PUSH1  0x16                         p = 22  = 42/2 
RETURN                              return data from memory p to p+ s  ===   22 to 22+10   = 22 to 32 memory byte

data from 22 to 32th memory bytes
0x602a60005260206000f3


calculating bytecode
Given : The opcode for PUSH1   is 0x60
        The opcode for PUSH10  is 0x69
        The opcode for MSTORE  is 0x52
        The opcode for RETURN  is 0xf3


        0x69 + 0x602a60005260206000f3  +  0x60+ 0x00  +  MSTORE +  0x60 +0x0a  +  0x60 + 0x16  +  RETURN
        ____________________________      __________     ____      __________     ___________     ______






*********************************************************
Creation code                                           *
bytecode = 0x69602a60005260206000f3600052600a6016f3     *
*********************************************************


_________________________________________Factory contract____________________________________________________________________

deploy this Creation code

*/


contract Factory
{
    event event_1(address adr);
    function deploy() public    // deploy this Creation code
    {
        bytes memory bytecode_ = hex"69602a60005260206000f3600052600a6016f3";
        // since  bytes take 0 to 32 memory byte to store bytecode_ variable
        // so 69602a60005260206000f3600052600a6016f3 will be executed from 33 to 64 memory bytes
        address adr;
        assembly
        {
            adr:= create(0,add(bytecode_ ,0x20),0x13)  // opcode create() => deploy smart contract
        }
        /* opcode create(,,)
                    take 3 input
                        1. amount of eth send 
                        2. location of code that we will going to deploy in memory  32 memory byte to  0x20()
                        3. size of bytecode  =  0x13
        */  
        require(adr != address(0), "error aagya yrr fer se");
        emit event_1(adr);
    }
}

