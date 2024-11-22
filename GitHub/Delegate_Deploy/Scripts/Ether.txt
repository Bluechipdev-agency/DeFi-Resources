const { ethers } = require("ethers");

async function main() {
    // Setup provider and signer (you can use MetaMask or another wallet provider)
    const provider = new ethers.JsonRpcProvider("http://localhost:8545"); // For local development, use the correct RPC URL
    const signer = provider.getSigner();  // Default signer (the first address in the wallet)

    // Deploy the Factory Contract (DelegateDeployFactory)
    const FactoryABI = [
        "function deployToken(address admin, uint256 initialSupply) external returns (address)"
    ];
    const FactoryAddress = "0x...";  // Replace with the deployed factory address
    const factoryContract = new ethers.Contract(FactoryAddress, FactoryABI, signer);

    // Call the deploy function to deploy a new token
    const adminAddress = "0x...";  // Replace with desired admin address
    const initialSupply = ethers.utils.parseUnits("1000000", 18); // 1 million tokens (adjust decimals if necessary)

    const tx = await factoryContract.deployToken(adminAddress, initialSupply);
    const receipt = await tx.wait();  // Wait for the transaction to be mined

    console.log("New Token deployed at:", receipt.events[0].args.tokenAddress);
    console.log("Admin Address:", receipt.events[0].args.admin);
    console.log("Initial Supply:", receipt.events[0].args.initialSupply.toString());
}

main().catch(console.error);
