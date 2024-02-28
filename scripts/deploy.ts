import { ethers } from "hardhat";

async function main() {
 ;

  const nftFactory = await ethers.deployContract("NftFactory");

  await nftFactory.waitForDeployment();

  console.log(
    `NftFactory deployed to ${nftFactory.target}`
  );

  const socialMedia = await ethers.deployContract("SocialMedia", [nftFactory.target]);

  await socialMedia.waitForDeployment();

  console.log(
    `SocialMedia deployed to ${socialMedia.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


//NftFactory deployed to 0xD7B08aa46DCF1360314fC84918928493a5a3fd63
//SocialMedia deployed to 0x3331ca2450017936BDcc461d7ccE8Cbd17BB9195