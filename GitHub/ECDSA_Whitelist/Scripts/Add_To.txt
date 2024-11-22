const userAddress = "0x..."; // Address to whitelist
const signature = "0x..."; // Signature generated off-chain

const contractAddress = "0x..."; // Deployed contract address
const abi = [ /* ABI of the ECDSAWhitelist contract */ ];

const provider = new ethers.JsonRpcProvider("https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID");
const signerWallet = new ethers.Wallet("0x...", provider);
const contract = new ethers.Contract(contractAddress, abi, signerWallet);

// Add the address to the whitelist
await contract.addToWhitelist(userAddress, signature);
