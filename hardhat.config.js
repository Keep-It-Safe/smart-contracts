require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    apothem: {
      url: "https://erpc.apothem.network",
      accounts: [process.env.PRIVATE_KEY],
    }
  },
};
