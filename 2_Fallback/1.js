let { ethers } = require('ethers');

let ABI = require('./ABI.json');
let PRIVATE_KEY = "";
let network = "";
let Contract_address = "0xC44a3cC86c0eC01F69187630e81aeCB2609eD58B";


let provider = new ethers.providers.JsonRpcProvider(network);                        // read from blockchain
let signer = new ethers.Wallet(PRIVATE_KEY, provider);                              //  write on blockchain
let i = new ethers.Contract(Contract_address,ABI,signer);                          // contract_instance

let a = async()=>
{
    await i.contribute({ value: ethers.utils.parseEther('0.000000000000003')});

    // Since 'receive' is a special function, you don't call it directly. Instead, initiate a transaction that sends ETH to the contract. The contract's 'receive' function will be triggered implicitly.
    
    

    let txn_1 = await signer.sendTransaction(                            // await guarantees that the transaction has been broadcast to the network and is pending.
    {
        to: Contract_address,
        value: ethers.utils.parseEther('0.000000000000000001'),       // Amount of ETH to send
        gasLimit: 3000000                                            // Adjust as needed
    });
    

    let receipt_1 = await txn_1.wait(); // To Avoid Double Speding attack -> check that transcation status change "pending" -> "successfull"  or ensure txn is mined 
    /*
        Block number where the transaction was included
            -> Gas used
            -> Event logs emitted by the contract (if any)
            -> Status (success or failure)
    */    

      
    let txn_2 = await i.withdraw();  
    
    console.log("before",txn_2.hash);   //***************  
    let receipt_2 = await txn_2.wait();
    console.log("after",txn_2.hash);   //*******************


    /*
    Both console print same txn has but why ? how ?
        The transaction hash is generated as soon as the transaction is created, even before it's mined. 
        It acts as a unique identifier and doesn't change regardless of the transaction's status. 
        That's why both console.log statements print the same hash.
    */


}
a().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});


/* 
This could lead to several issues:

Double spending  :   If the user clicks "Contribute" again while the first transaction is pending, you might  
                     unintentionally initiate a second transaction, potentially leading to double spending.

Premature success:   If the user sees the "Transaction pending" message and navigates away, they might assume 
                     their contribution succeeded even if it ultimately failed.


*/



