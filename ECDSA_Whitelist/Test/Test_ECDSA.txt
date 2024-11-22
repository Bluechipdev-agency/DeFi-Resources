const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ECDSAWhitelist Contract", function () {
  let ECDSAWhitelist;
  let whitelist;
  let owner;
  let addr1;
  let addr2;
  let signer;

  // Before each test, deploy a new contract
  beforeEach(async function () {
    // Get the signers
    [owner, addr1, addr2] = await ethers.getSigners();

    // Deploy the contract with the owner's address as the signer
    signer = owner.address; // In this test, we use the owner as the signer
    ECDSAWhitelist = await ethers.getContractFactory("ECDSAWhitelist");
    whitelist = await ECDSAWhitelist.deploy(signer);

    // Wait for deployment to finish
    await whitelist.deployed();
  });

  // Test: Verify that the contract correctly identifies a whitelisted address
  it("should add an address to the whitelist when a valid signature is provided", async function () {
    // Create the message that will be signed
    const userAddress = addr1.address;
    const messageHash = ethers.utils.solidityKeccak256(["address"], [userAddress]);
    const prefixedMessage = ethers.utils.arrayify(ethers.utils.hashMessage(ethers.utils.arrayify(messageHash)));
    
    // Sign the message using the signer's private key
    const signature = await owner.signMessage(prefixedMessage);

    // Call the addToWhitelist function with the signed message
    await whitelist.addToWhitelist(userAddress, signature);

    // Verify the address has been added to the whitelist
    expect(await whitelist.isWhitelisted(userAddress)).to.be.true;
  });

  // Test: Verify that the contract rejects an address with an invalid signature
  it("should not add an address to the whitelist if the signature is invalid", async function () {
    const userAddress = addr1.address;
    const invalidSignature = "0x" + "00".repeat(65); // Fake signature

    // Try adding the address with the invalid signature
    await expect(whitelist.addToWhitelist(userAddress, invalidSignature))
      .to.be.revertedWith("Invalid signature");

    // Verify the address is not whitelisted
    expect(await whitelist.isWhitelisted(userAddress)).to.be.false;
  });

  // Test: Verify that an address can be verified as whitelisted
  it("should correctly verify a whitelisted address", async function () {
    const userAddress = addr1.address;
    const messageHash = ethers.utils.solidityKeccak256(["address"], [userAddress]);
    const prefixedMessage = ethers.utils.arrayify(ethers.utils.hashMessage(ethers.utils.arrayify(messageHash)));

    // Sign the message using the signer's private key
    const signature = await owner.signMessage(prefixedMessage);

    // Add the address to the whitelist
    await whitelist.addToWhitelist(userAddress, signature);

    // Verify the address is whitelisted
    expect(await whitelist.isWhitelisted(userAddress)).to.be.true;
  });

  // Test: Ensure that non-whitelisted addresses cannot be verified
  it("should not allow non-whitelisted addresses to be verified", async function () {
    const nonWhitelistedAddress = addr2.address;
    // Ensure the address is not whitelisted
    expect(await whitelist.isWhitelisted(nonWhitelistedAddress)).to.be.false;
  });
});
