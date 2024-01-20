//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract calldata_
{
    
//____________________________________________static_variable______________________________________________
    function f1(uint256 i) public {}    // or function f1(uint i) public {}
    function f2(uint8 i,uint16 j,uint256 k) public {}
    function f3(bool i,bool j) public {}
    function f4(bytes8 i) public {}
    function f5(bytes8 i,bytes8 j) public {}

//____________________________________________Dynamic_variable______________________________________________
    function f4(bytes memory i) public {}
    function f7(bytes memory i,bytes memory j) public {}



/*
____________________________________Static Variable_______________________________________________________
    
    calldata = function selector + inputs

    f1(uint256) or f1(uint i)

    f1(11)                      0x  9adbf691 
                                    000000000000000000000000000000000000000000000000000000000000000b      (32 bytes)

    f1(90)                      0x  9adbf691 
                                    000000000000000000000000000000000000000000000000000000000000005a      (32 bytes)

    f1(1)                       0x  9adbf691 
                                    0000000000000000000000000000000000000000000000000000000000000001      (32 bytes)



    f1(uint8,uint16,uint256)
    f1(11,12,13)                0x  8963eb91 
                                    000000000000000000000000000000000000000000000000000000000000000a      (32 bytes)
                                    000000000000000000000000000000000000000000000000000000000000000b      (32 bytes)
                                    000000000000000000000000000000000000000000000000000000000000000c      (32 bytes)





    f1(bool,bool)
    f1(true,false)              0x  f6b3c4c6
                                    0000000000000000000000000000000000000000000000000000000000000001      (32 bytes)
                                    0000000000000000000000000000000000000000000000000000000000000000      (32 bytes)



    f1(byte8)
    f1(0xaaaaaaaaaaaaaaaa)      0x  082b191b
                                    aaaaaaaaaaaaaaaa000000000000000000000000000000000000000000000000      (32 bytes)




    f1(byte8,byte8)
    f1(0xaaaaaaaaaaaaaaaa)       0x  ac9117be
                                    aaaaaaaaaaaaaaaa000000000000000000000000000000000000000000000000      (32 bytes)
                                    aaaaaaaaaaaaaaaa000000000000000000000000000000000000000000000000      (32 bytes)




__________________________________________Dynamic Variable_____________________________________________________________________________________

    dynamic data(2 parts)  
            1.offset 
            2. data
                a. size
                b. actual data

        
        calldata  =  function selector   +    data Location     +    data(size + actual data inputs)

        calldata  =  function selector   +    data Location 1   +    data Location 2   +    data1(size + actual data inputs)   +   data2(size + actual data inputs)



        offset -> 1st input (after func selector)  == location of data  (like 20 ->32 means data will be start after 32 bytes (start as reference) )
        so why we need location of data -> because dynamic variable doesn't have fixed size
        so we need to know where data starts from so we can copy the data



    f1(bytes memory)
    f1(0xabcd)                  0x  b92aa8da
                            (start) 0000000000000000000000000000000000000000000000000000000000000020      location         = 20-> 32 bytes => after 32 bytes from start of this slot
                                    0000000000000000000000000000000000000000000000000000000000000002      sizes(in bytes)  = 2 bytes  
                                    abcd000000000000000000000000000000000000000000000000000000000000      actual data of 2 bytes

    f1(0xabcdef)                0x  b92aa8da
                                    0000000000000000000000000000000000000000000000000000000000000020
                                    0000000000000000000000000000000000000000000000000000000000000003
                                    abcdef0000000000000000000000000000000000000000000000000000000000
                



    f1(bytes memory i, bytes memory j)

    f1(0xaa,0xbbbb)             0x  925ffcc9
                            (start) 0000000000000000000000000000000000000000000000000000000000000040      location         = 40 -> 64 bytes => after 62 bytes from start of this slot
                                    0000000000000000000000000000000000000000000000000000000000000080      location         = 80 -> 128 bytes => after 62 bytes from start of this slot
                                    0000000000000000000000000000000000000000000000000000000000000001      sizes(in bytes)  = 1 bytes  
                                    aa00000000000000000000000000000000000000000000000000000000000000      actual data of 2 bytes
                                    0000000000000000000000000000000000000000000000000000000000000002      sizes(in bytes)  = 2 bytes  
                                    bbbb000000000000000000000000000000000000000000000000000000000000      actual data of 2 bytes

*/
}