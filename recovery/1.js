let rlp = require("rlp");
let keccak = require("keccak");


let contract_address =(sender,nonce)=>
{
    let rlp_encoded = rlp.encode([sender, nonce]);
    let contract_address_long = keccak("keccak256").update(rlp_encoded).digest("hex");
    return contract_address_long.substring(24,64); //Last 40 Hexadecimal.
}
console.log("0x  +  ",contract_address("0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8",0x01));

 // 0x80    ---->      nounce 0
//  0x01    ---->      nounce 1




