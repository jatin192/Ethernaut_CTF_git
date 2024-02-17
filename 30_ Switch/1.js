let { ethers } = require('ethers');

let ABI = require('./ABI.json');

let PRIVATE_KEY = ""
let network = ""

let Contract_address = "0xF65a1A6d8328789b770ee98F61462483C1b21fa8";


let provider = new ethers.providers.JsonRpcProvider(network);      // read from blockchain
let signer = new ethers.Wallet(PRIVATE_KEY, provider);            //  write on blockchain

let i = new ethers.Contract(Contract_address,ABI,signer);       // contract_instance

let main = async()=>
{
    let call_data = "0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000420606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000";

    let tx = await signer.sendTransaction(                               
    {
        to: Contract_address,
            gasLimit: 5000000,                                                  // Adjust as needed
            data : call_data,
           // value: ethers.utils.parseEther('0.000000000000000001'),         // Amount of ETH to send
    });
    await tx.wait() // to prevent double spending
    console.log(await i.switchOn());
}
main().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});

