let { ethers } = require('ethers');

let {ABI_} = require('./ABI');
let PRIVATE_KEY =  "";
let network = "";
let Contract_address = "0x1EaA13EBdBA32d5dF6cE2582963C0244633962be";


let provider = new ethers.providers.JsonRpcProvider(network);                        // read from blockchain
let signer = new ethers.Wallet(PRIVATE_KEY, provider);                              //  write on blockchain
let i = new ethers.Contract(Contract_address,ABI_,signer);                          // contract_instance

let a = async()=>
{
    let tx = await i.Fal1out({ value: ethers.utils.parseEther('0.000000000000003')});
    await tx.wait();
    let owner_ =await i.owner();
    console.log("owner=",typeof(owner_),owner_);
}

a().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});



