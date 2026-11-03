// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A
{
    function f() public view returns(address,address)
    {
        return f2();
    }
    function f2() public view returns(address,address)
    {
        return (msg.sender,address(this));
    }
}

contract B 
{
    function f3(A i) public view returns(address,address)
    {
        return i.f2();
    }
}