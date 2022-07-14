import { expect } from "chai";
import hre from "hardhat";
import { BigNumber, ethers } from 'ethers';

describe("Issuer", function () {
  let issuer: ethers.Contract;

  beforeEach(async () => {
    const tIssuer: ethers.ContractFactory = await hre.ethers.getContractFactory("Issuer");
    const tissuer: ethers.Contract = await tIssuer.deploy();
    await tissuer.deployed();
    issuer = tissuer;
  });

  it("enroll", async() => {
    const tOwner = "ethereum";
    const tRepo = "go-ethereum";
    const tx: ethers.ContractTransaction = await issuer.enroll(tOwner, tRepo);
    // receipt
    const receipt: ethers.ContractReceipt = await tx.wait()
    // could instead contract.on('event', async (...args: any[]))=>{})
    const enrollId: number = await issuer.callStatic.enroll(tOwner, tRepo) -1;
    console.log(await issuer.getURL(enrollId));
  });

  it("enrol count", async() => {
    const tOwner = "ethereum";
    const tRepo = "go-ethereum";
    const incorrectRepo = "cosmos-sdk";
    const tx: ethers.ContractTransaction = await issuer.enroll(tOwner, tRepo);
    await tx.wait();
    // 1
    console.log(await issuer.getRepoEnrollCount(tOwner, tRepo));
    // 0
    console.log(await issuer.getRepoEnrollCount(tOwner, incorrectRepo));
  });

  it("get url token pairs", async() => {
    const tOwner = "ethereum";
    const tRepo = "go-ethereum";
    const tx: ethers.ContractTransaction = await issuer.enroll(tOwner, tRepo);
    await tx.wait();

    //[ 'https://api.github.com/repos/', 'contributors?' ]
    console.log(await issuer.getUrlTokenPair(BigNumber.from("0")));

    await issuer.updateUrlToken("https://dbadoy", ".dev");
    // [ 'https://dbadoy', '.dev' ]
    console.log(await issuer.getUrlTokenPair(BigNumber.from("1")));    

    try {
      console.log(await issuer.getUrlTokenPair(BigNumber.from("2")));    
    } catch (error) {
      console.log('not exist index. expect errors.');
    }
  });
});
