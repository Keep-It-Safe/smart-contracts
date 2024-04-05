const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("KeepItSafeModule", (m) => {
  const KeepItSafeContract = m.contract("KeepItSafe");
  console.log(KeepItSafeContract);
  return {
    KeepItSafeContract
  }
});
