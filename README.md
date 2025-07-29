# Ethernaut_CTF

![Screenshot from 2024-06-06 10-43-45](https://github.com/jatin192/Ethernaut_CTF_git/assets/73174196/0d7ffe11-8734-4f99-8361-29b9c9d9cc5f)

# Notes

________________________________________________________1 Hello Ethernaut___________________________________________________________________________
Q1. providers   vs   signer
Q2. error handling


sol 1.

let provider = new ethers.providers.JsonRpcProvider(network)                        
let signer = new ethers.Wallet(PRIVATE_KEY, provider); 
                      ↓                                               vs                                    ↓
let i = new ethers.Contract(Contract_address,ABI,signer);                              let i = new ethers.Contract(Contract_address,ABI,provider);



provider
        ->  is primarily responsible for querying data from the Ethereum network, 
        ->  read from blockchain

signer    
        ->  has the additional capability to sign transactions and interact with the Ethereum network in a more active manner
        ->  write on blockchain



sol 2.

let a = async()=>
{
    await i.func_1();
}


a().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});

________________________________________________________2 Fallback__________________________________________________________________________________________

Q How to send Ether to smart contract who have receive function
Q Why This Two-Step Process Is Essential:     let txn = await ...    , let receipt = txn.wait();
q why txn.hash before tnx mined and after txn mined  is same




Sol. 1

    let txn_1 = await signer.sendTransaction(                      // await guarantees that the transaction has been broadcast to the network and is pending.
    {
        to: Contract_address,
        value: ethers.utils.parseEther('0.000000000000000001'),       // Amount of ETH to send
        gasLimit: 3000000                                            // Adjust as needed
    });


    let receipt = await txn_1().wait();  // check that transcation status change "pending" -> "successfull"
    /*
        Block number where the transaction was included
            -> Gas used
            -> Event logs emitted by the contract (if any)
            -> Status (success or failure)
    */





Sol. 2

      This could lead to several issues:

      Double spending  :   If the user clicks "Contribute" again while the first transaction is pending, you might  
                          unintentionally initiate a second transaction, potentially leading to double spending.

      Premature success:   If the user sees the "Transaction pending" message and navigates away, they might assume 
                          their contribution succeeded even if it ultimately failed.




Sol. 3

    console.log("before",transaction.hash);   
    let receipt = await i.withdraw();           // check that transcation status change "pending" -> "successfull"  or ensure txn is mined 
    console.log("after",transaction.hash);

    /*
    Both console print same txn has but why ? how ?
        The transaction hash is generated as soon as the transaction is created, even before it's mined. 
        It acts as a unique identifier and doesn't change regardless of the transaction's status. 
        That's why both console.log statements print the same hash.
    */


________________________________________________________3 Fallout__________________________________________________________________________________________

Q1  I have interface + contract Contract_address  -> then how can i interact with smart contract using javascript

Q2  Problem :When you have (contract address + source code) But you can’t deploy in Remix so can’t call any function because of 
    Error: not found openzeppelin-contracts-06/math/SafeMath.sol
    Or  Version Problem




sol. 1

ABI.js
            let ABI_ =[    
                        "function Fal1out() external payable ",
                        "function owner() external view returns (address)", 
                    ]
            module.exports = {ABI_};

1.js

            let {ABI_} = require('./ABI');




sol. 2
        use interface 


________________________________________________________4 Coin Flip__________________________________________________________________________________________

Error: cannot estimate gas; transaction may fail or may require manual gas limit ?


sol.

await i.func(1,2,{gasLimit: 5000000});


________________________________________________________5 Telephone__________________________________________________________________________________________

tx.origin  =  Always points to an EOA, never a smart contract.
msg.sender =  Can be either an EOA or a smart contract.


________________________________________________________6 Tokenn__________________________________________________________________________________________


_____________________________________________________________________
|     Version	Default         |      Underflow/Overflow Checks     |
|_______________________________|____________________________________|
|                               |                                    |
|      Before 0.8.0	            |              No                    |
|      0.8.0 and later	        |              Yes (for both)        |
|_______________________________|____________________________________|



________________________________________________________7 Delegation__________________________________________________________________________________________________


Q1 How to calculate calldata ?
Q2 calldata vs function signature ? which one should pass to delegate call ?
Q3 Error : delgation call not working in remix ?
Q4 How to call Fallback function using js?
Q5 Normal external call vs Delegate call ?






1.
      Method 1
      using solidity -> 
                        contract calculate_sig_contract 
                        {
                              bytes public i = abi.encodeWithSignature("pwn(string,bool,uint16)", "hello",true,3);   // bytes: 0xcf6a2989000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000668656c6c6f770000000000000000000000000000000000000000000000000000

                                                    or
                              bytes public i = abi.encodeWithSignature("pwn()");           // 0xdd365b8b
                        }
      


      Method 2
      using Remix(local network)

                        -> contract calculate_sig_contract 
                        {
                              function pwn(string memory input1,bool input2, uint16 input3) public {/*....*/} 
                                          // call function -> input -> copy -> Transact 
                                                            or
                                          // copy calldata directly(see under the function while calling)
                        }
      


      Method 3 
      using js
                        let ethers = require('ethers');
                        let abiCoder = new ethers.utils.AbiCoder();

                        function calculate_Func_Signature(string_i,bool_i,uint16_i) 
                        {
                        let params =                                         // Define the function parameters
                        [
                              { type: 'bool', name: 'i', value: bool_i },
                              { type: 'uint16', name: 'j', value: uint16_i },
                              { type: 'string', name: 'k', value: string_i },
                              // { type: 'bytes8', name: 'm', value: bytes8_i }
                        ];

                        let encoded_parameters = abiCoder.encode(params.map(param => param.type), params.map(param => param.value));  // Encode the parameters
                        let functionSignature = ethers.utils.keccak256(ethers.utils.toUtf8Bytes('pwn(string,bool,uint16)'));    // Calculate the Keccak-256 hash of the function signature
                        let calldata = functionSignature.substring(0, 10) + encoded_parameters.substring(2);                        // Prepend the function signature to the encoded parameters

                        return calldata;
                        }

                        // Example usage
                        let bool_i = true;
                        let uint16_i = 3;
                        let string_i = "hello";
                        let bytes8_i = "0x1234567890abcdef";

                        // let calldata = calculate_Func_Signature(string_i,bool_i, uint16_i);
                        // console.log(`Calldata: ${calldata}`);

                        module.exports = {calculate_Func_Signature};
      
            

2.
      calldata = functionSignature + encoded parameters

      you pass the entire calldata, including the function signature, to the delegate call.
      Signature here means the first 8 bytes of the sha3 (alias for keccak256)hash of the function prototype




3.
      edit GasLimit in Metamask



4.

      let txn_1 = await signer.sendTransaction(                               
      {
          to: Contract_address,
          gasLimit: 5000000,                                                  // Adjust as needed
          data : signature_,
         // value: ethers.utils.parseEther('0.000000000000000001'),        // Amount of ETH to send
      });


5.
 	Assume : delegation call  contract B -> contract A 

	****Delegation call use storage of B But functionality of A  

      Assume : Normal external call  contract B -> contract A   (example :  adr.func_1()  )

	****Use storage and functionality of A  




Resources

We can verify the hash using this online keccak 256 hash tool by inputing 
https://emn178.github.io/online-tools/keccak_256.html 

Also, you can get the contract ABI from etherscan, and paste it into this tool: 
https://abi.hashex.org/# 


________________________________________________________8 Force__________________________________________________________________________________________________

Q1 How to Transfer Eth to smart contract which don’t have any receive()/Fallback() or payable function 
Q2 Transfer Eth to C without changing b value

        contract C 
        {
            uint public b;
            receive() external payable {b= 2;}
        }





Sol 1.

selfdestruct(owner_address)   // Suicide >> Loss



Sol 2.

Selfdestruct  -> Transfer all fund from smartcontract D -> contract_C without calling receive funtion

contract C 
{
    uint public a;
    receive() external payable {a= 2;}
}

contract D
{
    c j;
    constructor(address payable i){j= C(i);}
    function f1() payable  public 
    {
	selfdestruct(payable(j))
    }
    receive() external payable( ) { }
}



Resource
https://betterprogramming.pub/solidity-what-happens-with-selfdestruct-f337fcaa58a7


________________________________________________________9 Vault__________________________________________________________________________________________________

1. Is private variable is really private ?🤯
2. How to read contract storage ? 
3. Technique to make our private variable is really private😇



1. 
    Marking a variable as private onfrly prevents other contracts from accessing it. 
    State variables marked as private variables are still publicly accessible.


2. 
    In js
                let Print_1st_5_slots = async()=>
                {
                    for (let slot = 0; slot < 3; slot++)
                    {
                        console.log(`[${slot}]` + 
                        await provider.getStorageAt(Contract_address, slot));
                    }
                }
                Print_1st_5_slots();

    In solidity
                bytes32 public slot_0 = (keccak256(abi.encode(uint256(0))));
                bytes32 public slot_1 = (keccak256(abi.encode(uint256(1))));


3. 
        To ensure that data is private, it needs to be encrypted before being put onto the blockchain

        1. Storing Hashes and Off-Chain Encryption: keeping the actual data private off-chain.

        Example:
                Imagine a voting system on the blockchain. 
                You want to keep individual votes anonymous while ensuring the integrity of the overall count. 
                Storing votes directly would expose voters' choices, violating privacy.

        Steps->
        Off-Chain:
                Encrypt the private data using a secure algorithm and key.
                Calculate the hash of the encrypted data (e.g., SHA-256).
        On-Chain:
                Store the calculated hash on the blockchain.
                Keep the encryption key and encrypted data securely off-chain.
        Verification:
                Anyone can verify the integrity of the data by recalculating the hash from the provided encrypted data and comparing it to the stored hash on-chain.
                Only authorized parties holding the encryption key can decrypt and access the actual data.



        contract DataStore 
        {
            mapping(address => bytes32) public dataHashes;

            function storeData(bytes32 dataHash) public 
            {
                dataHashes[msg.sender] = dataHash;
            }

            function verifyData(bytes memory encryptedData) public view returns (bool) 
            {
                bytes32 calculatedHash = keccak256(encryptedData);
                return dataHashes[msg.sender] == calculatedHash;
            }
        }






        2. Utilizing Off-Chain Oracles:


        Steps:

        Oracle Setup:
                    Choose a trusted oracle provider with secure data storage and access control mechanisms.
                    Store the private data with the oracle.
        On-Chain Interaction:
                    The smart contract interacts with the oracle through pre-defined functions or APIs.
                    The oracle retrieves and verifies the data based on specific conditions set in the smart contract (e.g., user authentication, authorization token).
                    The oracle returns only the necessary data to the smart contract without exposing the entire dataset.
        Benefits:
                    More flexible access control compared to simple hashes.
                    Reduces on-chain storage costs.
                    Leverages expertise of trusted oracle providers for secure data management.



        contract DataConsumer 
        {
            address public oracleAddress;

            constructor(address _oracleAddress) 
            {
                oracleAddress = _oracleAddress;
            }

            function accessData(bytes32 accessKey) public 
            {
                // Call oracle function to retrieve and verify data based on accessKey
                bytes memory data = getOracleData(accessKey);
                // Process and utilize the retrieved data
            }

            function getOracleData(bytes32 accessKey) internal returns (bytes memory) 
            {
                // Replace with actual oracle interaction call
                return _oracle(accessKey);
            }
        }



Resources
https://blog.ethereum.org/2016/12/05/zksnarks-in-a-nutshell








_________________________________________10_King________________________________________________________________________________________________________________________________________________

Q1 transfer  vs  call   ? which is better?

Q2  after calling destruct() still
    a.  is it possible to sc to receive money?
    b.  to call any function ?
    c.  contract Storage before vs after ? same or different?






1.
    a.  Confusion ???
    b.  No 
    c. 
        Confusion ??
            Before destruct(): The contract's storage holds its current data, like the balance you mentioned.
            After destruct(): The storage becomes undefined or inaccessible. The contract's balance and any other stored data are essentially erased.


2.

    transfer        
            - It limits the amount of gas available to the recipient contract to 21,000 gas.
            - This is often not sufficient if the receiving contract performs complex operations or makes external calls during the fallback function.
            - The idea behind limiting the gas is to prevent reentrancy attacks, where an attacker could repeatedly call back into the sender contract during the transfer.


                                    vs  


    call{value: msg.value, gas: 50000, from: msg.sender}(data)

            - The call function provides more control over the gas limit and allows the caller to specify the amount of gas to be sent along with the function call.
            - It returns a tuple with a boolean indicating success and the returned data.
            - Using call allows the sender to provide more gas to the recipient contract, making it more suitable for cases where the recipient contract may require additional gas to execute its code.
            - May cause Re-entrancy Attack




Notes:   

1.         contract A                  ->        contract B (have receive function)
   (use .call insted of transfer)

2. selfdestruct function  ->  Transfer all the fund from one smartcontract to another smartcontract or EOA without calling refceive function










________________________________________________________11_Reentrancy__________________________________________________________________________


Q1  Error : call to Hack.i
            call to Hack.i errored: Error occured: invalid argument 0: json: cannot unmarshal hex number > 64 bits into Go struct field TransactionArgs.gas of type hexutil.Uint64.

            invalid argument 0: json: cannot unmarshal hex number > 64 bits into Go struct field TransactionArgs.gas of type hexutil.Uint64


Q2  So many internal txn -> Txn failed due to less gas fee 
Q3  get balance of another contract ?




1. Gas Limit (remix) 5M

2. set Gas Limit to max in Metamask (see in images)

3. address(adr).balance;








________________________________________________________12_Elevator__________________________________________________________________________



Q1   contract instances ??  contract_1  i  =     new contract_1(1,2)     vs     contract(msg.sender)      vs      contract(adr)     ?????

Q2   In every new instance. Is address changes every time.

Q3 
    Importance of view Keyword
    f1()    did't return value correctly  (return value only show in remix console)
    f2()    return 899 correctly 



        contract A
        {
            uint public  a=889;
        }

        contract B 
        {
            function f(A i) public returns (uint)
            {
                return i.a();
            }
            function f2(A i) public view returns (uint)
            {
                return i.a();
            }
        }


Q4 can we use dynamic arrays inside function ? 




Ans 1

contract A
{
    function(B adr) public
    {
        adr.load_instance();
    }
}

contract B
{
    function load_instance() public view returns (address)                 //  This fucntion is only called by other Already deployed B contract
    {
        A i = A(msg.sender);                                             // load contract , msg.sender == already deployed contract address(!EOA) 
        return  address(i);
    }

        // or

    function load_instance(address adr) public view returns (address)
    {
        A i = A(adr);                                                  // load contract , adr ==  deployed contract address 
        return  address(i);
    }

}

contract C
{
    constructor(uint adr, uint a)
}

contract D
{
    function create_instance() public  returns (address)
    {
        C i = new C(1,2);                                        // creating  new instance with new  contract addresses every time
    } 
}





C i = new C(2,3);                ->           This code snippet creates a new instance of contract C type, assigning it to a variable named i. It then calls the constructor of contract C, passing the values 1 and 2 as arguments.

Requirement
A must have a constructor that accepts two integer arguments
When creating contract instances, ensure the constructor arguments match the expected types and meanings within the contract.






1   A i = A(msg.sender)               ->        create instance by loading contract at msg.sender address ,msg.sender should be a contract address
        or
2   A i = A(adr) 

Requirement
costructor have no impact
adr, msg.sender must be a contract address(!EOA)
you cant directly instract  in 1 becaue in direct interaction msg.sender == EOA    -> 1stly deploy A i which func external call to contract A 's function() {A i = A(msg.sender) }



Ans 2   : Yes  check using address(i)


Ans 3

        f1()     did't return value correctly  (return value only show in remix console)
        f2()     return 899 correctly 

        Because of View Keyword




Ans 4
        The push() function is not available for dynamic arrays in memory

        function functionName() public view returns (uint[] memory) 
        {
	        uint[] memory dynamicArray = new uint[](9);  // Initialize with size = 9
	        // dynamicArray.push(2);   ------> Error
            dynamicArray[8]=2;
		}








Additional Information

Always use solidity^<0.8.20

Potential Issue:            PUSH0 is a relatively new opcode.
                            Solidity versions 0.8.20 and above use the PUSH0 opcode (0x5f) which is only supported by Ethereum mainnet currently. 
                            Deploying to other chains with an older EVM might cause "invalid opcode"  error.

Functionality:              PUSH0 acts as a shortcut for placing the number 0 on the stack during contract execution.

Benefits:                   Reduced Code Size:    Compared to previous methods using multiple opcodes, PUSH0 reduces the bytecode size of your smart contract, making it more efficient.
                            Less DUP Usage   :    It eliminates the need for workarounds like using DUP instructions for duplicating zeros.

________________________________________________________13_Privacy__________________________________________________________________________




1.  a. Is private variable is really private in smart contracts ?
    b. Is the first public state variable acqurie whole slot 0 ?    
                         &
    c. When you assign bytes32 Globale variable. will it directly store in contract storage  without any additional encoding or formatting?

2.  can reading and writing to such slots without the need for inline assembly? But wait when we call any function that change Global variable that also change the Storage slots  data



1. 
        bool a =true;        
        bool b = true;
        bytes32 c;
        bytes32 i = bytes32(0x8f6b597142094e5b463af0876ec9c6a9a686ee1a958ad77aab7fd138ab96bcf7);
        
        ->    
            [0]0x0000000000000000000000000000000000000000000000000000000000000101
            [1]0x0000000000000000000000000000000000000000000000000000000000000000
            [2]0x0000000000000000000000000000000000000000000000000000000000000000  
            [3]0x8f6b597142094e5b463af0876ec9c6a9a686ee1a958ad77aab7fd138ab96bcf7 

    a. NO    
                            
    b. NO
                           
    c. YES
       When you assign bytes32(0x8f6b597142094e5b463af0876ec9c6a9a686ee1a958ad77aab7fd138ab96bcf7) to i, 
       the entire 32-byte value is copied directly into the allocated storage slot for i



2.
    Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
    This library helps with reading and writing to such slots without the need for inline assembly.





Notes    
_____________________________________________________________________________
|   int       or   uint		    ==   	 256 bits 	 ==  		32 bytes     |
|   int8      or   uint8 		==   	 8 bits      ==  		1 bytes      |
|   int 256   or   uint256      ==       256 bits 	 ==  		32 bytes     |
|                                                                            |
|   bytes1              		==   	 8 bits 	 ==  		1 bytes      |
|   bytes32              		==   	 256 bits 	 ==  		32 bytes     |
|                                                                            |        
|   bool			         	==       8 bits	     ==  	 	1 byte       |
|                                                                            |
|   address payable or address  ==       160 bits    ==         20 byte      |
|____________________________________________________________________________|


0x     5035551062b14c8b2982d1bd2ecbf387db35e224e52fd8e9ced6eba9f4ebcd5b
2   +  64 Hexadecimal 


0x     50     35    55  …………………………………………….        5b
        1   +  1   +  1	+						+  1
       byte   byte   byte						  byte
 

1 byte = 2 Hexadecimal = 8 bits 






Resources 

->  https://medium.com/@dariusdev/how-to-read-ethereum-contract-storage-44252c8af925
->  https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/StorageSlot.sol



Error TypeError: Cannot read properties of undefined (reading 'JsonRpcProvider')  -> use ethers@5.




_______________________________________14_Gatekeeper One____________________________________________________


Notes

1.   try/cath in solidity
    
    Try and catch only work for external calls and contract creation.
    function attack() public  returns (bool)
    {
        for(uint k=1;k <= 8191;k++)
        {
            // try and catch only work for external calls and contract creation.
            try i.enter{gas: 8191*10 + k}(0x000a000000008d4B)
            {
                loop = k;
                return true;
            }
            catch
            {

            }
        }
        return false;
    }

 2.   Do not use JavaScript in this case it was totally waste of time 
      use solidity to save time & gas




3.

Example

1 byte = 2 Hexadecimal = 8 bits 
byte8 = 0x ff..........16th hexadecimal
bytes1----bytes32

uint8 = 8 bits

uint16(uint160(n))   ==   uint16(uint64(uint32(n)))  ==    uint16(n)

Hexadecimal 0x  ff  ee  ab  cd  ef  09  10  15
(bytes8)                                    _____
                                            uint8
                                        ________
                                        uint16
                                ________________
                                uint32
                ______________________________
                uint64
                                             
_______________________________________15_Gatekeeper Two________________________________________________________________________

1.  How to check  given address is address of smart contract ? or EOA ?  
2.  Can a contract access the code of another contract? How to get Bytecode of entire smart contract using there address ?
3.  Assembly ?




1 Ans. 

    3 Methords 

    1.  using address(adr).code     ->     provides the bytecode of smart contract, not the actual source code
                                    ->     You can verify if a contract exists at a particular address by checking if its bytecode is non-empty. 

    2.  opcode extcodesize(adr)	    ->     size of the code at address adr
                                    ->     only returns the correct value once the contract is constructed. 
                                    ->     Returns 0 if it is called from the constructor of a contract.                                  */
    
    3.  modifier onlyEoa() 
        {
            require(tx.origin == msg.sender, "Not EOA");
            _;
        }   


    modifier onlyEoa() 
    {
        require(tx.origin == msg.sender, "Not EOA");
        _;
    }  

                          or


    function isContract1(address adr) public view returns (bool)
    {
        return (adr.code.length > 0);
    }                

                          or


    function isContract2(address _addr) public view returns (bool)
    {
        uint32 size;
        assembly 
        {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }


2 Ans. 
        No,
        there's no method to directly access another contract's internal state or storage using address(adr).code in Solidity. 
        It's fundamentally designed to provide bytecode accessibility, not internal data retrieval.
        
        function getCode(address a) public view returns (bytes memory) 
        { 
            return a.code; 
        } 



3 Ans. 

    The assembly keyword is your gateway to the raw power of the EVM. It allows you to write low-level code directly using the EVM's instruction set, called opcodes.

    Two types of Assembly:

    1. Inline Assembly: This lets you interleave assembly code within your Solidity source code using the assembly { ... } block. You can interact with local Solidity variables and access various EVM capabilities.
    2. Standalone Assembly: This involves writing a separate assembly file, which can be linked to your Solidity contract. This approach gives you more control and flexibility but is also more complex.

    Benefits of using assembly:

    1. Fine-grained control   : You can perform tasks not directly possible with Solidity, such as manipulating memory at a lower level or interacting with specific EVM opcodes.
    2. Gas optimization       : In some cases, assembly can be more gas-efficient than Solidity code, leading to lower transaction fees.
    3. Enhanced functionality : Accessing low-level functionalities like bit manipulation or custom cryptographic operations.


    Important considerations:

    1. Complexity         : Assembly adds another layer of complexity to your contract, making it harder to understand and maintain.
    2. Security risks     : Assembly bypasses many of Solidity's safety features, so you need to be extra careful to avoid errors and vulnerabilities.
    3. Development effort : Learning assembly and writing secure code requires significant effort and expertise.




Notes 
        a ^ b == c
        a ^ c == b

        xor(^)

        1 ^ 1  = 0
        0 ^ 1  = 1

        ************* byte32 = keccak256(abi.encodePacked(msg.sender));
        keccak256 always return a 32-byte (64-character hexadecimal) string


Resources

https://ethereum.stackexchange.com/questions/15641/how-does-a-contract-find-out-if-another-address-is-a-contract
https://ethereum.stackexchange.com/questions/1906/can-a-contract-access-the-code-of-another-contract




_________________________________________16_Naught Coin________________________________________________________________________


Notes

    1.  When are import any Library or contract you should know how everything is working in imported contract or Library.  
        ->  In this example, a developer might scan through the code and think that transfer is the only way to move tokens around,
            low and behold there are other ways of performing the same operation with a different implementation.

    2.  Constructor cannot be defined in interfaces.
        Functions in interfaces cannot have modifiers.

    3.  account1 -> approve account2 -> check allowance  
        change to account 2-> TransferFrom() 
        you can't call TransferFrom from account1  

Resources
https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts
https://github.com/ethereum -> search erc



_______________________________________17_Preservation_________________________________________________________________________________________________



1.  length of address
        Ethereum Account  vs  smart contract  vs  Transaction
2.  can delegate call override/update the contract storage ?
3.  how to convert address -> uint
4.  address vs bytes   (in Solidity)
5.  we have to state variable of different datatype of same value and same length. Is hash present in contract storage is different or same ?
6.  why a & c have different value But still don't worry   ^_^
    
        bytes30 public a; // 0x8d...4b00000000000000000000
        uint240 public b; // 0x000000000000000000008d...4b
        bytes30 public c;

        a= bytes30(bytes20(0x8DAB96e9241b68A488948c1421e4776D333b8d4B));   
        b= uint240(uint160(0x8DAB96e9241b68A488948c1421e4776D333b8d4B));
        c= bytes30(b);
        






1.
Length = Ethereum Account  =  smart contract = 40  Hexadecimal  (excluding 0x)
                                    
                                    0x      8DAB96e9241b68A488948c1421e4776D333b8d4B
                                    __      ________________________________________
                                    2                     40

Length = Transaction = 64 Hexadecimal (excluding 0x)

                                    0x      df2f8d5b64a81e1fd5885233204e48464a85a782a6b089679650ca731f4d1104
                                    __      _______________________________________________________________
                                    2                     64

2.
yes
delegate call 
-> importing (code) function call and variable that use in that function  at runtime into this contract 
-> it behaves as if it's being executed directly over here so it carries forward the storage
    contract A 
    {
        address x;
        uint y;
        
        bytes4  i = bytes4(keccak256("func_1(address,uint256)"));
        delegatecall(abi.encodePacked(i,,2));
    }
    contract B 
    {
        uint e;
        address f;
        func_1()
    }


3.
    when you're converting one datatype into another make sure that bits/bytes/Hexadecimal storage length must be same 
    No need to worry when you convert in same data types like uint8 -> uint256 ->uint160
    like

    address -> uint256
   
    Wrong   uint256(address(0xabc......40th hexadecimal))
    Right   unt256(uint160(address(0xabc......40th hexadecimal))) 

4.
Purpose:

address             --->    is specifically designed to store Ethereum account addresses, which are 20 bytes long.
bytes8,...,bytes32  --->    is a general-purpose fixed-size byte array that can store any 8->32 bytes respectively.

 Right   address(0x8DAB96e9241b68A488948c1421e4776D333b8d4B);  
 Right   bytes20(0x8DAB96e9241b68A488948c1421e4776D333b8d4B);
 Wrong   address(0xdf2f8d5b64a81e1fd5885233204e48464a85a782a6b089679650ca731f4d1104);
 Right   bytes32(0xdf2f8d5b64a81e1fd5885233204e48464a85a782a6b089679650ca731f4d1104);


6.
a stores the bytes 0x8dab...0000 as-is, including the padding.
c stores the bytes 0x0000...8dab to represent the integer value correctly in big-endian format.

    contract storage & slots
    a->[0]0x00008dab96e9241b68a488948c1421e4776d333b8d4b00000000000000000000
    b->[1]0x0000000000000000000000008dab96e9241b68a488948c1421e4776d333b8d4b


Suggestion 
Assumption length of address/bytes always after excluding 0x      until the .length function not used like in paddint using javaScript




_________________________________________18_Recovery__________________________________________________________________


Q1. I have caller_address + nouce , How to calculate/compute smart contract address ? 
Q2. "new" keyword in Solidity?





1.
    smart contract address = last 20 bytes(RLP encoded (msg.sender, nonce) )  // not tx.origin


        ( 0xd6 ,  0x94 ,    sender_address   ,     0x01 )
        _____________                           ______   
        identify that                           nounce
        this is an
            address


    encoding 0xd6 , 0x94  identifies that this is an address

    RLP = Recursive Length Prefix
            -> Efficient data serialization: 
                    -> It encodes data structures (strings, lists, nested items) into a compact and standardized format. 
                    -> This facilitates efficient communication and synchronization between nodes on the network.




    In js

    let contract_address =(sender,nonce)=>
    {
        let rlp_encoded = rlp.encode([sender, nonce]);
        let contract_address_long = keccak("keccak256").update(rlp_encoded).digest("hex");
        return contract_address_long.substring(24,64); //Last 40 Hexadecimal.
    }


    In solidity

    return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94),i, bytes1(0x80))))));

    return  address(uint160(uint256(keccak256(abi.encodePacked(      bytes1(0xd6), bytes1(0x94)   ,          i        ,   bytes1(0x01))))));  
                                                                      _________________________      ______________       _____________   
                                                                       identify that this is an      sender_address         nounce
                                                                       address
    
     //  0x80    ---->      nounce 0
    //   0x01    ---->      nounce 1





2. 

    new == new instance with uinique & different address

    deploy contract A -> call func_1() -> automatically internal call to  deploy instance of contract B 

    contract A
    {
        function func_1() public pure returns(B)
        {
            B i = new B(1,2);
            return i;
        }
    }
    contract B
    {
        constructor(uint a,uint b) {}
    }



Resources : 
https://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed 
https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp



_______________________________________19_Magic Number_______________________________________________________________________________

1. How to convert Hexadecimal to Number ?
2. write smart contract using only opcodes ?
3. I have Runtime bytcode can i know how many opcode used ? 



1. 
    Convert hexadecimal number 3F5 to decimal:

    5 is in the 16^0 place (5 * 1 = 5)
    F is in the 16^1 place (15 * 16 = 240)
    3 is in the 16^2 place (3 * 256 = 768)
    5 + 240 + 768 = 1013


2.
    check 2.sol file in Magic Number
    
    steps
        Runtime code
        Creation code
        Factory contract


3.
    https://www.evm.codes/playground?fork=shanghai




Resources

https://www.evm.codes/?fork=shanghai

EVM playground : https://www.evm.codes/playground?fork=shanghai






_______________________________________20_Alien Codex__________________________________________________________________________________


1. abi.encode  or  ABI encoding ??
2. keccak256 ??
3. maximum storage slot in smart contract in Solidity
4. 0.5.0 + bytes[] array  ???????



1.
        ABI encoding is a way to represent data types in a standardized way 
        so that they can be passed between different contracts and applications on the Ethereum blockchain.


2.
        keccak256(...)
                This applies the Keccak-256 hash function to the encoded value. 
                it is a cryptographic hash function that produces a unique 256-bit output for any given input
                Hash functions are used to create unique, tamper-proof fingerprints of data.


3.
        the maximum storage slot possible in a Solidity smart contract is 2^256

        slot_0 
        slot_1 
        ......
        ......
        ......
        slot_255  == 256-1


4.
        underflow -> access all contract storage slots
        it exploits the arithmetic underflow of array length, by expanding the array's bounds to the entire storage area of 2^256. The user is then able to modify all contract storage.
                





_________________________________________________21_Denial_________________________________________________________________________________________________________________________________________




Q1  Is assert still consume all gas in 0.8.0 solidity version ?
Q2  Methods to consume all the gas 

1
    Before solidity 0.8.0,
    the 𝐚𝐬𝐬𝐞𝐫𝐭() 𝐬𝐭𝐚𝐭𝐞𝐦𝐞𝐧𝐭 𝐜𝐨𝐧𝐬𝐮𝐦𝐞 𝐚𝐥𝐥 𝐠𝐚𝐬 𝐢𝐧 𝐚 𝐭𝐫𝐚𝐧𝐬𝐚𝐜𝐭𝐢𝐨𝐧

    But After solidity 0.8.0, 
    the 𝐚𝐬𝐬𝐞𝐫𝐭() 𝐬𝐭𝐚𝐭𝐞𝐦𝐞𝐧𝐭 𝐝𝐨𝐞𝐬𝐧’𝐭 𝐜𝐨𝐧𝐬𝐮𝐦𝐞 𝐚𝐥𝐥 𝐠𝐚𝐬 𝐢𝐧 𝐚 𝐭𝐫𝐚𝐧𝐬𝐚𝐜𝐭𝐢𝐨𝐧. It now 𝐫𝐞𝐭𝐮𝐫𝐧𝐬 𝐭𝐡𝐞 𝐫𝐞𝐦𝐚𝐢𝐧𝐢𝐧𝐠 𝐠𝐚𝐬 𝐛𝐚𝐜𝐤 𝐭𝐨 𝐭𝐡𝐞 𝐬𝐞𝐧𝐝𝐞𝐫
    However, since Solidity version 0.8.0, the assert() function now uses the REVERT opcode, 
    which does not consume all gas in a transaction but actually returns any remaining gas to the transaction’s sender.
    With this change, the REVERT opcode now allows for better gas management, providing users with greater control over their gas usage.




2

        pragma solidity ^0.8.0;
        receive() external payable 
        {
            assembly
            {
                invalid()      
            }
            //consume all gas  & txn fails  
        }


                or 



        pragma solidity ^0.8.0;
        receive() external payable 
        { 
            while(true)
            {
                a=a+1; 
            }
        }


                or



        pragma solidity <0.8.0;
        receive() external payable 
        { 
            assert(false);    
        }

   




Resources
https://hackernoon.com/an-update-to-soliditys-assert-statement-you-mightve-missed




______________________________________________________22_Shop_______________________________________________________________________________

































_______________________________________28_Gatekeeper_Three______________________________________________________________________________________________


Constructor vs fucntion



Q1. 
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






solution 1 

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



Note 

    1. Try to avoid performing action inside constructor if you interfact with instances/external-internal call  -> use function instead
    2. constructor code is executed sequentially from top to bottom -> there is no chance for other code to be interleaved between the calls
