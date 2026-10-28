let ethers = require('ethers');
let abiCoder = new ethers.utils.AbiCoder();

function calculate_Func_Signature() 
{
    let params =                                         // Define the function parameters
    [
        // { type: 'bool', name: 'i', value: bool_i },
        // { type: 'uint16', name: 'j', value: uint16_i },
        // { type: 'string', name: 'k', value: string_i },
        // { type: 'bytes8', name: 'm', value: bytes8_i }
    ];

    let encoded_parameters = abiCoder.encode(params.map(param => param.type), params.map(param => param.value));// Encode the parameters
    let functionSignature = ethers.utils.keccak256(ethers.utils.toUtf8Bytes('pwn()'));                         // Calculate the Keccak-256 hash of the function signature
    let calldata = functionSignature.substring(0, 10) + encoded_parameters.substring(2);                      // Prepend the function signature to the encoded parameters

    return calldata;
}

// Example usage
// let bool_i = true;
// let uint16_i = 3;
// let string_i = "hello";
// let bytes8_i = "0x1234567890abcdef";

let calldata = calculate_Func_Signature();
// console.log(`Calldata: ${calldata}`);

module.exports = {calldata};