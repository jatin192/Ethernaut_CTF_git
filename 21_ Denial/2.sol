
//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;  // <0.8.0
contract Hack3
{
    receive() external payable 
    { 
        assert(false);    
    }
}
/*
Before solidity 0.8.0,
the 𝐚𝐬𝐬𝐞𝐫𝐭() 𝐬𝐭𝐚𝐭𝐞𝐦𝐞𝐧𝐭 𝐜𝐨𝐧𝐬𝐮𝐦𝐞 𝐚𝐥𝐥 𝐠𝐚𝐬 𝐢𝐧 𝐚 𝐭𝐫𝐚𝐧𝐬𝐚𝐜𝐭𝐢𝐨𝐧

But After solidity 0.8.0, 
the 𝐚𝐬𝐬𝐞𝐫𝐭() 𝐬𝐭𝐚𝐭𝐞𝐦𝐞𝐧𝐭 𝐝𝐨𝐞𝐬𝐧’𝐭 𝐜𝐨𝐧𝐬𝐮𝐦𝐞 𝐚𝐥𝐥 𝐠𝐚𝐬 𝐢𝐧 𝐚 𝐭𝐫𝐚𝐧𝐬𝐚𝐜𝐭𝐢𝐨𝐧. It now 𝐫𝐞𝐭𝐮𝐫𝐧𝐬 𝐭𝐡𝐞 𝐫𝐞𝐦𝐚𝐢𝐧𝐢𝐧𝐠 𝐠𝐚𝐬 𝐛𝐚𝐜𝐤 𝐭𝐨 𝐭𝐡𝐞 𝐬𝐞𝐧𝐝𝐞𝐫
However, since Solidity version 0.8.0, the assert() function now uses the REVERT opcode, 
which does not consume all gas in a transaction but actually returns any remaining gas to the transaction’s sender.
With this change, the REVERT opcode now allows for better gas management, providing users with greater control over their gas usage.
*/