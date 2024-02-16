let { ethers } = require('ethers');

// let ABI = require('./ABI.json');
// let PRIVATE_KEY = "";
let network = ""
let Contract_address = ""; // contract C
// const slot = 1; // Replace with the storage slot to query


let provider = new ethers.providers.JsonRpcProvider(network);      // read from blockchain
// let signer = new ethers.Wallet(PRIVATE_KEY, provider);            //  write on blockchain

// let i = new ethers.Contract(Contract_address,ABI,signer);       // contract_instance

let main = async()=>
{
    for (let slot = 0; slot < 5; slot++)
    {
        console.log(`[${slot}]` + 
        await provider.getStorageAt(Contract_address, slot));
    }
}
main().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});

