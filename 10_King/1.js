const { ethers } = require('ethers');

let ABI = require('./ABI.json');
let PRIVATE_KEY = ""
let network = "" //sepolia
let Contract_address = "0x3D92B8dd74929f38096F48378d73F02D239923fb";


let provider = new ethers.providers.JsonRpcProvider(network);                        // read from blockchain
let signer = new ethers.Wallet(PRIVATE_KEY, provider);                              //  write on blockchain
let i = new ethers.Contract(Contract_address,ABI,signer);                          // contract_instance

let main = async()=>
{
    let Print_1st_5_slots = async()=>
    {
        for (let slot = 0; slot < 5; slot++)
        {
            console.log(`[${slot}]` + 
            await provider.getStorageAt(Contract_address, slot));
        }
    }

    await Print_1st_5_slots();

    let tx = await i.suicide_();
    await tx.wait();
    console.log("after selfdestruct");
    
    await Print_1st_5_slots();
    

}

main().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});