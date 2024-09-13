import { ethers } from "hardhat";
import { expect } from "chai";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { EventNFT, NftGatedEvent } from "../typechain";  

describe("NftGatedEvent", () => {
  let nftToken: EventNFT;
  let eventContract: NftGatedEvent;
  let owner: SignerWithAddress;
  let creator: SignerWithAddress;
  let attendee: SignerWithAddress;

  beforeEach(async () => {
    [owner, creator, attendee] = await ethers.getSigners();

 
    const NFTFactory = await ethers.getContractFactory("EventNFT");
    nftToken = await NFTFactory.deploy() as EventNFT;
    await nftToken.deployed();


    const EventFactory = await ethers.getContractFactory("NftGatedEvent");
    eventContract = await EventFactory.deploy(nftToken.address) as NftGatedEvent;
    await eventContract.deployed();
  });

  it("should mint an NFT for the creator", async () => {
    const tokenURI = "ipfs://example-uri";
    
    // Mint an NFT for the creator
    await nftToken.connect(owner).mint(tokenURI);
    
    // Verify that the NFT is owned by the owner
    const balance = await nftToken.balanceOf(owner.address);
    expect(balance).to.equal(1);
  });

  it("should allow creator to create an event after minting an NFT", async () => {
    const tokenURI = "ipfs://example-uri";
    
    // Mint an NFT for the creator
    await nftToken.connect(owner).mint(tokenURI);
    
    // Verify that the creator owns an NFT
    const balance = await nftToken.balanceOf(owner.address);
    expect(balance).to.equal(1);
    
    // Create an event
    await expect(
      eventContract.connect(owner).createEvent(
        "Test Event", 
        "Event Description", 
        "2024-09-15", 
        "12:00", 
        100
      )
    ).to.emit(eventContract, "EventSuccessfulCreated");
  });

  it("should not allow non-NFT holders to create events", async () => {
    await expect(
      eventContract.connect(creator).createEvent(
        "Test Event", 
        "Event Description", 
        "2024-09-15", 
        "12:00", 
        100
      )
    ).to.be.revertedWith("YouHaveToMintAnNFT");
  });

  it("should allow attendees to register for an event", async () => {
    const tokenURI = "ipfs://example-uri";
    
    // Mint an NFT and create an event
    await nftToken.connect(owner).mint(tokenURI);
    await eventContract.connect(owner).createEvent(
      "Test Event", 
      "Event Description", 
      "2024-09-15", 
      "12:00", 
      100
    );
    
    // Register the attendee
    await expect(
      eventContract.connect(attendee).registerForEvent(owner.address, 1, "John Doe", "john@example.com")
    ).to.emit(eventContract, "RegistrationSuccesful");
    
    // Check the attendee is registered
    const isRegistered = await eventContract.hasRegistered(attendee.address);
    expect(isRegistered).to.be.true;
  });
});
