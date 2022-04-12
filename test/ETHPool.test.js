import { expect } from 'chai'
import { ethers } from 'hardhat'
import '@nomiclabs/hardhat-ethers'

const { getContractFactory, getSigners } = ethers

describe('ETHPool', () => {
  let owner, user1, user2, user3, user4, user5
  let ETHPool

  beforeEach(async () => {
    ;[owner, user1, user2, user3, user4, user5] = await getSigners()
    ETHPool = await getContractFactory('ETHPool')
    contract = await ETHPool.deploy()

    await contract.deployed()
  })

  it('Allow deposits', async function () {
    const deposit = ethers.BigNumber.from(1000000000000000000)
    await owner.sendTransaction({
      to: contract.address,
      value: deposit,
    })
    expect(await contract.total()).to.equal(deposit)
  })
})
