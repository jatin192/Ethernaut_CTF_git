// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A
{ 
    uint public  a=19;
    function func_1(B adr) public view
    {
        adr.load_instance();
    }

    function increment () public {   a++;   }
}

contract B
{
    function load_instance() public view returns (uint)             //  This fucntion is only called by other Already deployed B contract
    {
        A i = A(msg.sender);                                             // load contract , msg.sender == already deployed contract address(!EOA) 
        return  i.a();
    }

        // or


    function load_instance(address adr) public view returns (uint)
    {
        A i = A(adr);                                                  // load contract , adr ==  deployed contract address 
        return i.a();
    }
}

contract C
{
    uint public a =19;
    constructor(uint j, uint k){    }
    function increment () public { a++;}
}

contract D
{
    C i;
    function create_instance() public // returns (uint)
    {
        i = new C(1,2);                                        // creating  new instance with new  contract addresses every time
        // return  i.a();                                     // since we are calling the func of other contract so create_instance() function must be view(uneverisal)  & we can't change to view because of i = new C(1,2);
    } 
    function check() public view returns (uint)
    {
        return  i.a();
    }
}

