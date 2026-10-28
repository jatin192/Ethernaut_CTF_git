// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;
contract A
{

/*  checking address is of smart contract or EOA  (2 Methords): 

    1.  using address(adr).code     ->     provides the bytecode of smart contract, not the actual source code
                                    ->     You can verify if a contract exists at a particular address by checking if its bytecode is non-empty. 

    2.  opcode extcodesize(adr)	    ->     size of the code at address adr
                                    ->     only returns the correct value once the contract is constructed. 
                                    ->     Returns 0 if it is called from the constructor of a contract.   
    
    3.  modifier onlyEoa() 
        {
            require(tx.origin == msg.sender, "Not EOA");
            _;
        }                                                                                                                                                     */
    

    //1
    modifier onlyEoa() 
    {
        require(tx.origin == msg.sender, "Not EOA");
        _;
    }   
    

    //2
    function isContract1(address adr) public view returns (bool)
    {
        return (adr.code.length > 0);
    }


    //3
    function isContract2(address _addr) public view returns (bool)
    {
        uint32 size;
        assembly 
        {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    //understanding
    function getCode(address a) public view returns (bytes memory) { return a.code; } 
}