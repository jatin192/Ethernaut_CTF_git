let { ethers } = require('ethers');

// let ABI = require('./ABI.json');
// let PRIVATE_KEY = "";
let network = "https://polygon-mumbai.g.alchemy.com/v2/BigcFnXEKcriMiJUtLFLBAk_TRjyrfic";
let Contract_address = "0x469209B5eF73870E9Dc6367065A29A3529Ed05Ce";


let provider = new ethers.providers.JsonRpcProvider(network);      // read from blockchain
// let signer = new ethers.Wallet(PRIVATE_KEY, provider);            //  write on blockchain

// let i = new ethers.Contract(Contract_address,ABI,provider);       // contract_instance

let main = async() =>
{
    let Print_1st_5_slots = async()=>
    {
        for (let slot = 0; slot < 5; slot++)
        {
            console.log(`[${slot}]` + 
            await provider.getStorageAt(Contract_address, slot));
        }
    }

    Print_1st_5_slots();
}


main().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});

