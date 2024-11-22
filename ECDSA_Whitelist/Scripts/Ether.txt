const { ethers } = require("ethers");

// Signer's private key (this should be securely managed, don't hardcode it in production)
const signerPrivateKey = "0x..."; // Replace with your private key
const provider = new ethers.JsonRpcProvider("https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID");
const signer = new ethers.Wallet(signerPrivateKey, provider);

// The address you want to whitelist
const userAddress = "0x..."; // Address to whitelist

// Create the message hash
const message = ethers.utils.solidityKeccak256(["address"], [userAddress]);

// Prefix the message (Ethereum signed message prefix)
const prefixedMessage = ethers.utils.arrayify(ethers.utils.hashMessage(ethers.utils.arrayify(message)));

// Sign the message
const signature = await signer.signMessage(prefixedMessage);

console.log("Signature:", signature);
