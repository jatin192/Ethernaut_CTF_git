let { ethers } = require('ethers');
let ABI = require('./ABI.json');
let call_data = require('./call_data.js')

let PRIVATE_KEY = "";
let network = "";
let Contract_address = "0x41adE6AA16E9388d10ADa13EA10ac3128a1D0A56";

let provider = new ethers.providers.JsonRpcProvider(network);                        // read from blockchain
let signer = new ethers.Wallet(PRIVATE_KEY, provider);                              //  write on blockchain
let i = new ethers.Contract(Contract_address,ABI,signer);                          // contract_instance

let main = async()=>
{
    let func_sig = call_data.calldata;
    console.log("call_data : ",func_sig);

    // fallback function
      let txn_1 = await signer.sendTransaction(                               
      {
          to: Contract_address,
          gasLimit: 5000000,                                                  // Adjust as needed
          data : func_sig,
         // value: ethers.utils.parseEther('0.000000000000000001'),         // Amount of ETH to send
      });

      await txn_1.wait();  


}

main().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});



// 0xcf6a2989000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000568656c6c6f000000000000000000000000000000000000000000000000000000
// 0xcf6a2989000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000568656c6c6f000000000000000000000000000000000000000000000000000000