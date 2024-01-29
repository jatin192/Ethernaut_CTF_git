
let hre = require("hardhat");

async function main() 
{
  let [deployer] = await ethers.getSigners();
  let constructor_arugument = "0xD2313a4597ea56c7be2ed3EF56fF2C98244Aa294";
  let valueToSend = hre.ethers.parseEther("0.00000000000000001");  // Specify the value to be sent along with the deployment or to constructorEE
  
  let i = await hre.ethers.deployContract( "Hack", [constructor_arugument], {value: valueToSend,}  );
  await i.waitForDeployment();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("contract address:", await i.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
