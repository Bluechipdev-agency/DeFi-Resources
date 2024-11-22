async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Specify the ERC-20 token address
    const tokenAddress = "0x..."; // Replace with actual ERC-20 address
    const StakingContract = await ethers.getContractFactory("ERC20Staking");
    const stakingContract = await StakingContract.deploy(tokenAddress);
    console.log("Staking contract deployed to:", stakingContract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
