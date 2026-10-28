// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.9.6/token/ERC20/ERC20.sol";  //adjust @4.9.6 acc.. to solc version

contract Malicious_Token is ERC20
{
    constructor()ERC20("Malicious_Token", "Malicious_Token_symbol")
    {
        _mint(msg.sender, 300);
    }
}
