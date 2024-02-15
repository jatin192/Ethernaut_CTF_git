let { ethers } = require('ethers');
let ABI = require('./ABI.json');    // SimpleToken  paste code in remix -> compile -> get ABI



let rlp = require("rlp");
let keccak = require("keccak");



let PRIVATE_KEY = ""
let network = ""

let main = async()=>
{

//_______________________________________________________________________________________________________________________________________________
    let contract_address =(sender,nonce)=>
    {
        let rlp_encoded = rlp.encode([sender, nonce]);
        let contract_address_long = keccak("keccak256").update(rlp_encoded).digest("hex");
        return contract_address_long.substring(24,64); //Last 40 Hexadecimal.
    }

                                                  // msg.sender = Recovery               ,  Nounce
    let Contract_address = await contract_address("0x3FaD70CF087447d624297bbfe24aD6932C8590B4" ,  0x01  ); 
    //  0x80    ---->      nounce 0
    //  0x01    ---->      nounce 1

    Contract_address = "0x"+Contract_address;
    console.log("Contract_address =",Contract_address);
//__________________________________________________________________________________________________________________________________________________



    let provider = new ethers.providers.JsonRpcProvider(network);                             // read from blockchain
    let signer = new ethers.Wallet(PRIVATE_KEY, provider);                                   //  write on blockchain
    let i = new ethers.Contract(Contract_address,ABI,signer);                               // contract_instance

    let Metamask_account = "0x8DAB96e9241b68A488948c1421e4776D333b8d4B";

    let tx =await i.destroy(Metamask_account);
    console.log("receipt =",await tx.wait());

}

main().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});

















