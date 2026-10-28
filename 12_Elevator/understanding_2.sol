// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A
{
    uint public  a=889;
}

contract B 
{
    function f(A i) public returns (uint)
    {
        return i.a();
    }
    function f2(A i) public view returns (uint)
    {
        return i.a();
    }
}


// f did't return value correctly  (return value only show in remix console)
// f return 899 correctly 

// Because of View Keyword