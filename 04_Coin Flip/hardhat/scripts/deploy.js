let hre = require("hardhat");
async function main() 
{
    let [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // let constructor_arugument = "0xecf80539AeB6fc05589183248fbD6dF335Ae18c1";
    
    let i = await hre.ethers.deployContract( "Hack");
    console.log("contract address:", await i.getAddress());
}


main()
 .then(() => process.exit(0))
 .catch((error) => {
   console.error(error);
   process.exit(1);
 });
