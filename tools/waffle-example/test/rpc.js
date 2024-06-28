import {expect, use} from 'chai';
import ethers from 'ethers';
import {deployContract, MockProvider, solidity} from 'ethereum-waffle';
import SampleContract from '../contracts/SampleContract.json' assert { type: "json" };

use(solidity);

describe('BasicToken', () => {
    let token;

    beforeEach(async () => {
        token = await deployContract(
            new ethers.providers.Web3Provider().getSigner(),
            SampleContract,
            [],
        );
    });

    it('Emits event', async () => {
        await expect(token.emitEvent())
            .to.emit(token, 'Notification')
            .withArgs("Hello world");
    });

    it('Test revert', async () => {
        await expect(token.revertableFunction()).to.be.reverted;
    });
});