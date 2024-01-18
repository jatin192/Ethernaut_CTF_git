const { ethers } = require('ethers');
// Replace with your preferred provider URL

const provider = new ethers.providers.JsonRpcProvider('https://polygon-mumbai.infura.io/v3/ffd685538dee4ee3bca98e5b475fb524');

const address = '0x67E514b158f27A6905e8B57f17bC31f11129c40C';// contract Privacy 2nd wala 
let Print_1st_10_slots = async()=>
{
    for (let slot = 0; slot < 10; slot++)
    {
        console.log(`[${slot}]` + 
        await provider.getStorageAt(address, slot));
    }

    // console.log('Storage value:', await provider.getStorageAt(address, slot));
}

Print_1st_10_slots();

let b = async()=>
{
    const slot = 5; 
    let i= await provider.getStorageAt(address, slot);

    //requirement in Question
    console.log(i.slice(0,34));  // bytes16 = 32 hexadecimal
}

b();
// Output: a hexadecimal string representing the value





//Error
//TypeError: Cannot read properties of undefined (reading 'JsonRpcProvider')  -> use ethers@5.