// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy 
{
  bool public locked = true;                               // slot 0 
  uint256 public ID = block.timestamp;                    //  slot 1
  uint8 private flattening = 10;                         //   slot 2
  uint8 private denomination = 255;                     //    slot 2
  uint16 private awkwardness = uint16(block.timestamp);//     slot 2
  bytes32[3] private data;                            //      data[0]   -> 32 byte    slot  3 
                                                     //       data[1]   -> 32 byte    slot  4 
                                                    //        data[2]   -> 32 byte    slot  5 
  constructor(bytes32[3] memory _data) 
  {
    data = _data;
  }

  function unlock(bytes16 _key) public 
  {
    require(_key == bytes16(data[2]));
    locked = false;
  }
}


/*  _______________________________________________________________________________________________________________________________

contract Privacy // Understanding 
{
        bool a =true;        
        bool b = true;
        bytes32 c;
        bytes32 d;
        bool e =true;
        bool f = true;
        bytes32 g;
        bytes32 h;
        bytes32 i = bytes32(0x8f6b597142094e5b463af0876ec9c6a9a686ee1a958ad77aab7fd138ab96bcf7);
        bytes32 j;


        [0]0x0000000000000000000000000000000000000000000000000000000000000101
        [1]0x0000000000000000000000000000000000000000000000000000000000000000
        [2]0x0000000000000000000000000000000000000000000000000000000000000000
        [3]0x0000000000000000000000000000000000000000000000000000000000000101
        [4]0x0000000000000000000000000000000000000000000000000000000000000000
        [5]0x0000000000000000000000000000000000000000000000000000000000000000
        [6]0x8f6b597142094e5b463af0876ec9c6a9a686ee1a958ad77aab7fd138ab96bcf7
        [7]0x0000000000000000000000000000000000000000000000000000000000000000
}
*/