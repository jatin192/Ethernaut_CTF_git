let hre = require("hardhat");
async function main() 
{
    let [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    let constructor_arugument = "0x4621B7bb33c5b72a9af39F6cbCA8a4B31F2cf69b";
    
    let i = await hre.ethers.deployContract( "Hack", [constructor_arugument]);
    console.log("contract address:", await i.getAddress());
}


main()
 .then(() => process.exit(0))
 .catch((error) => {
   console.error(error);
   process.exit(1);
 });
