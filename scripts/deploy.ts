import hre from "hardhat";
import { ethers } from "ethers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

async function main() {
  const url = "";
  // testnet
  const signer: SignerWithAddress = (await hre.ethers.getSigners())[0];
  // // mainnet
  // const provider: ethers.providers.JsonRpcProvider = new ethers.providers.JsonRpcProvider(url);
  // const { LedgerSigner } = require('@anders-t/ethers-ledger');
  // const signer = new LedgerSigner(provider);
  const Contract: ethers.ContractFactory = await hre.ethers.getContractFactory("Issuer", signer);
  const contract: ethers.Contract = await Contract.deploy();
  await contract.deployed();
  console.log(`deployed Issuer smart contract.\nurl : ${url}\naddress : ${contract.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});