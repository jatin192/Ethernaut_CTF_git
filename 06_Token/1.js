let { ethers } = require('ethers');

let ABI = require('./ABI.json');
let PRIVATE_KEY = "";
let network = "";
let Contract_address = "0x010971480b715ce6Cbdec2a3eD84F01Ec55A0172";


let provider = new ethers.providers.JsonRpcProvider(network);                        // read from blockchain
let signer = new ethers.Wallet(PRIVATE_KEY, provider);                              //  write on blockchain
let i = new ethers.Contract(Contract_address,ABI,signer);                          // contract_instance


let main = async()=>
{
    let txn = await i.transfer("0xC589F695a61F41eC1cc1f73c4d4db8a137C7B7d9",21);
    let receipt = await txn.wait();          //  To Avoid Double spending Attack   ->   check that transcation status change "pending" -> "successfull"  or ensure txn is mined 
    console.log("txn = ",txn.hash); 
    console.log("receipt = ",receipt); 
      

}
main().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});




