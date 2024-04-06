require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    apothem: {
      url: "https://erpc.apothem.network",
      accounts: [process.env.PRIVATE_KEY],
    },
    polygon: {
      url: `https://polygon-amoy.g.alchemy.com/v2/${process.env.API_KEY}`,
      accounts: [process.env.PRIVATE_KEY_AMOY]
    },
    coinex: {
      url: "https://testnet-rpc.coinex.net",
      accounts: [process.env.PRIVATE_KEY_COINEX]
    }
  },
};
