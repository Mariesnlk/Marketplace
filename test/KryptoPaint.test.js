const { assert } = require('chai')


const KryptoPaint = artifacts.require('./KryptoPaint');

//chack for chai 
require('chai')
    .use(require('chai-as-promised'))
    .should()

contract('KryptoPaint', (accounts) => {

    let contract

    before(async () => {
        contract = await KryptoPaint.deployed()
    })

    //testing container - describe

    describe('deployment', async () => {
        //test contaract deployment
        it('deploys successfuly', async () => {
            const address = contract.address;
            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
            assert.notEqual(address, 0x0)
        })

        //test name of contract
        it('name matches on contract', async () => {
            const getName = await contract.name()
            assert.equal(getName, 'KryptoPaint')
        })

        //test symbol of contract
        it('symbol matches on contract', async () => {
            const getSymbol = await contract.symbol()
            assert.equal(getSymbol, 'KPAINTZ')
        })
    })


    describe('minting', async () => {

        it('creates a new token', async () => {
            const minting = await contract.mint('https...1')
            const totalSupply = await contract.totalSupply()

            assert.equal(totalSupply, 1)

            const event = minting.logs[0].args
            assert.equal(event._from, '0x0000000000000000000000000000000000000000', 'from a contract')
            assert.equal(event._to, accounts[0], 'to is message sender')

            await contract.mint('https...1').should.be.rejected;
        })
    })

    describe('indexing', async () => {

        it('list of KrtyptoPaintz', async () => {
            await contract.mint('https...2')
            await contract.mint('https...3')
            await contract.mint('https...4')
            const totalSupply = await contract.totalSupply()

            let resultList = []
            let kryptoPaint

            for (let i = 1; i <= totalSupply; i++) {
                kryptoPaint = await contract.kryptoPaintz(i - 1)
                resultList.push(kryptoPaint)
            }

            let expected = ['https...1', 'https...2', 'https...3', 'https...4']
            assert.equal(resultList.join(','), expected.join(','))
        })
    })

    describe('ERC721 functions', async () => {

        it('checking balance of owner address', async () => {
            const balanceOf = await contract.balanceOf('0xb00437022691E0ceac72b503F2a93Fb0A528C31D')
            assert.equal(balanceOf, 4)
        })

        it('checking address is owned of NFT', async () => {
            const ownerOfFirst = await contract.ownerOf(0)
            const ownerOfLast = await contract.ownerOf(3)

            assert.equal(ownerOfFirst, '0xb00437022691E0ceac72b503F2a93Fb0A528C31D')
            assert.equal(ownerOfLast, '0xb00437022691E0ceac72b503F2a93Fb0A528C31D')

            await contract.ownerOf(4).should.be.rejected;
        })
    })

    describe('approving', async () => {

        it('approving address with NFT token', async () => {
            await contract.approve('0xf01D95B4615C288dE674c8996fCA2aFDf395782F', 0)

            const balanceOfOwner = await contract.balanceOf('0xb00437022691E0ceac72b503F2a93Fb0A528C31D')
            assert.equal(balanceOfOwner, 4)

            const isApprovedAddress = await contract.isApprovedAddress('0xf01D95B4615C288dE674c8996fCA2aFDf395782F', 0)
            assert.equal(isApprovedAddress, true)
        })
    })

})