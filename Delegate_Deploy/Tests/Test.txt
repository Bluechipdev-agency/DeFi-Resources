const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DelegateDeployFactory", function () {
  let DelegateDeployFactory;
  let simpleERC20;
  let factory;
  let owner;
  let admin;
  let initialSupply;

  beforeEach(async function () {
    // Get the signers (deployer, admin, etc.)
    [owner, admin] = await ethers.getSigners();
    initialSupply = ethers.utils.parseUnits("1000000", 18); // 1 million tokens

    // Deploy the factory contract
    const DelegateDeployFactoryContract = await ethers.getContractFactory("DelegateDeployFactory");
    factory = await DelegateDeployFactoryContract.deploy();
    await factory.deployed();

    // Deploy the SimpleERC20 contract (just for reference, as the factory should deploy it)
    const SimpleERC20Contract = await ethers.getContractFactory("SimpleERC20");
    simpleERC20 = await SimpleERC20Contract.deploy(admin.address, initialSupply);
    await simpleERC20.deployed();
  });

  it("should deploy a new SimpleERC20 token with correct admin and initial supply", async function () {
    // Call the deployToken function to deploy a new SimpleERC20 token via the factory
    const tx = await factory.deployToken(admin.address, initialSupply);
    const receipt = await tx.wait();

    // Get the deployed token address from the event
    const tokenAddress = receipt.events[0].args.tokenAddress;
    const deployedToken = await ethers.getContractAt("SimpleERC20", tokenAddress);

    // Check the token admin and initial supply
    const tokenAdmin = await deployedToken.admin();
    const tokenSupply = await deployedToken.balanceOf(admin.address);

    // Verify the token was deployed with the correct admin and initial supply
    expect(tokenAdmin).to.equal(admin.address);
    expect(tokenSupply).to.equal(initialSupply);
  });

  it("should emit a TokenDeployed event on successful token deployment", async function () {
    // Listen for the TokenDeployed event
    await expect(factory.deployToken(admin.address, initialSupply))
      .to.emit(factory, "TokenDeployed")
      .withArgs(ethers.utils.getAddress(admin.address), initialSupply);
  });

  it("should allow transferring tokens after deployment", async function () {
    // Deploy a new token using the factory
    const tx = await factory.deployToken(admin.address, initialSupply);
    const receipt = await tx.wait();
    const tokenAddress = receipt.events[0].args.tokenAddress;

    // Get the deployed token
    const deployedToken = await ethers.getContractAt("SimpleERC20", tokenAddress);

    // Transfer some tokens
    const transferAmount = ethers.utils.parseUnits("100", 18); // Transfer 100 tokens
    await deployedToken.transfer(owner.address, transferAmount);

    // Check the balances after the transfer
    const adminBalance = await deployedToken.balanceOf(admin.address);
    const ownerBalance = await deployedToken.balanceOf(owner.address);

    // Verify the balances
    expect(adminBalance).to.equal(initialSupply.sub(transferAmount));
    expect(ownerBalance).to.equal(transferAmount);
  });
});
