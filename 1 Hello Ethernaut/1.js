let { ethers } = require('ethers');

let ABI = require('./ABI.json');
let PRIVATE_KEY = "821bb94aa24de0c3ff6ef682a846f522f36dcba12b8a5de819811bcb592f43ea";
let network = "https://polygon-mumbai.g.alchemy.com/v2/BigcFnXEKcriMiJUtLFLBAk_TRjyrfic";
let Contract_address = "0xfB8Dd40b453ed945cB60E1C6655f16E045a64bf6";


let provider = new ethers.providers.JsonRpcProvider(network);
let wallet = new ethers.Wallet(PRIVATE_KEY, provider);

let i = new ethers.Contract(Contract_address,ABI,wallet); //contract_instance

let a = async()=>
{
    let password_ = await i.password();
    console.log("password =",password_);
    await i.authenticate(password_);
    console.log("contract address =",i.address);
}
a().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});