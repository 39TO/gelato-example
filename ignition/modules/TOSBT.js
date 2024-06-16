const {buildModule} = require("@nomicfoundation/hardhat-ignition/modules");

const FORWARDER_ADDRESS = "0xd8253782c45a12053594b9deB72d8e8aB2Fca54c";

module.exports = buildModule("SBTModule4", (m) => {
  const forwarder = m.getParameter("forwarder", FORWARDER_ADDRESS);
  const nft = m.contract("TOSBT", [forwarder]);
  return { nft };
});
