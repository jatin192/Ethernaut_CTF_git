// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

interface IFallout {
    function Fal1out() external payable;
    function allocate() external payable;
    function allocatorBalance(address allocator) external view returns (uint256);
    function collectAllocations() external;
    function owner() external view returns (address payable);
    function sendAllocation(address payable allocator) external;
}
