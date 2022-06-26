const hre = require("hardhat");

async function main() {
  
  const PromNeur = await hre.ethers.getContractFactory("PromNeur");
  const promNeur = await PromNeur.deploy();

  await promNeur.deployed();

  console.log("PromNeur deployed to:", promNeur.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
