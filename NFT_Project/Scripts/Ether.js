async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const NFT = await ethers.getContractFactory("BasicNFT");
    const nft = await NFT.deploy();
    console.log("NFT contract deployed to:", nft.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
