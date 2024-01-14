const { ethers } = require('ethers');
// Replace with your preferred provider URL
const provider = new ethers.providers.JsonRpcProvider('https://polygon-mumbai.infura.io/v3/ffd685538dee4ee3bca98e5b475fb524');

const address = '0x7f036897e8C8413c3de4717B24366d023e6Db310'; // Replace with the contract address
// const slot = 1; // Replace with the storage slot to query


let a = async()=>
{
    for (let slot = 0; slot < 10; slot++)
    {
        console.log(`[${slot}]` + 
        await provider.getStorageAt(address, slot));
    }

    // console.log('Storage value:', await provider.getStorageAt(address, slot));
}
a();
 // Output: a hexadecimal string representing the value


//TypeError: Cannot read properties of undefined (reading 'JsonRpcProvider')