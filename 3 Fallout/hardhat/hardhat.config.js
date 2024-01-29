require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
/** @type import('hardhat/config').HardhatUserConfig */


module.exports = {
  solidity: "0.6.0",
  networks: 
  {
    mumbai: 
    {
      url: process.env.Alchemy_API_KEY,
      accounts: [process.env.PRIVATE_KEY], // Your private key (securely stored as an environment variable)
    },
  },
};

  