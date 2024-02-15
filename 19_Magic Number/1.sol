//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// adr is the contract that uses <=10 opcode to return 42 

contract Factory
{
    constructor(MagicNum i) 
    {
        bytes memory bytecode_ = hex"69602a60005260206000f3600052600a6016f3";  // deploy this Creation code
        address adr;
        assembly
        {
            adr:= create(0,add(bytecode_ ,0x20),0x13)  // opcode create() => deploy smart contract
        }
        require(adr != address(0), "error aagya yrr fer se");
        i.setSolver(adr);
    }
}

 /* 
    since  bytes take 0 to 32 memory byte to store bytecode_ variable
    so 69602a60005260206000f3600052600a6016f3 will be executed from 33 to 64 memory bytes

    opcode create(,,)
                    take 3 input
                        1. amount of eth send 
                        2. location of code that we will going to deploy in memory  32 memory byte to  0x20()
                        3. size of bytecode  =  0x13
*/ 


//I have Runtime bytcode can i know how many opcode used ?   -> https://www.evm.codes/playground?fork=shanghai


contract MagicNum {

  address public solver;

  constructor() {}

  function setSolver(address _solver) public {
    solver = _solver;
  }

  /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
  */
}



