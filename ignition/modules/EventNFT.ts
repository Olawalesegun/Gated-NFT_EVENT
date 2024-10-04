import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const EventNFTModule = buildModule("EventNFTModule", (m) => {
  const eventNft = m.contract("EventNFT");

  return { eventNft };
});

export default EventNFTModule;