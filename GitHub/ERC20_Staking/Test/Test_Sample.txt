// Import the necessary Hardhat libraries
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeting Contract", function () {
  let Greeting;
  let greeting;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    // Get the ContractFactory and Signers
    Greeting = await ethers.getContractFactory("Greeting");
    [owner, addr1, addr2] = await ethers.getSigners();

    // Deploy the contract with an initial greeting message
    greeting = await Greeting.deploy("Hello, World!");
  });

  it("should set the initial greeting", async function () {
    // Test the initial greeting set in the constructor
    expect(await greeting.getGreeting()).to.equal("Hello, World!");
  });

  it("should allow the owner to set a new greeting", async function () {
    // The owner sets a new greeting
    await greeting.setGreeting("New Greeting");

    // Verify the greeting has been updated
    expect(await greeting.getGreeting()).to.equal("New Greeting");
  });

  it("should not allow non-owners to set a new greeting", async function () {
    // Attempt to set the greeting by a non-owner address
    await expect(greeting.connect(addr1).setGreeting("Non-owner Greeting"))
      .to.be.revertedWith("Ownable: caller is not the owner");

    // Ensure the greeting remains unchanged
    expect(await greeting.getGreeting()).to.equal("Hello, World!");
  });

  it("should emit an event when the greeting is updated", async function () {
    // Listen for the GreetingUpdated event
    await expect(greeting.setGreeting("Updated Greeting"))
      .to.emit(greeting, "GreetingUpdated")
      .withArgs("Updated Greeting");
  });

  it("should allow the owner to set a greeting after other changes", async function () {
    // Owner sets the greeting to another value
    await greeting.setGreeting("Second Greeting");

    // Verify the greeting has been updated
    expect(await greeting.getGreeting()).to.equal("Second Greeting");

    // Now, the owner sets another greeting
    await greeting.setGreeting("Final Greeting");

    // Verify the final greeting
    expect(await greeting.getGreeting()).to.equal("Final Greeting");
  });
});
