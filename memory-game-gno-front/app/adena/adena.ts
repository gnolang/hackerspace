import {
    EAdenaResponseStatus,
    EAdenaResponseType,
    IAccountInfo,
    IAdenaMessage,
    IAdenaResponse
} from './adena.types';
import { BroadcastTxCommitResult } from '@gnolang/tm2-js-client';

export class AdenaService {

    static waitForAdena(timeout = 5000, interval = 100): Promise<void> {
        return new Promise((resolve, reject) => {
            const start = Date.now();

            const checkAdena = () => {
                if (window.adena) {
                    resolve();
                } else if (Date.now() - start > timeout) {
                    reject(new Error('Adena wallet extension not found within timeout.'));
                } else {
                    setTimeout(checkAdena, interval);  // Retry every 'interval' milliseconds
                }
            };

            checkAdena();
        });
    }

    static async validateAdena(): Promise<void> {
        try {
            await this.waitForAdena();  // Wait for the extension to load
            console.log('Adena wallet found');
        } catch (error) {
            console.error('Adena wallet validation failed:', error);

            throw new Error('Adena not installed');
        }
    }

    // Establishes a connection to the Adena wallet, if any.
    // If the Adena wallet is not installed, it opens up the adena homepage
    static async establishConnection(name: string): Promise<void> {
        await AdenaService.validateAdena();

        // This should be injected by the extension
        const adena = window.adena;

        // Establish a connection to the wallet
        if (!adena) {
            throw new Error('Adena is not defined');
        }
        const response = await adena.AddEstablish(name) as IAdenaResponse;

        // Parse the response
        if (
            response.status === EAdenaResponseStatus.SUCCESS ||
            response.type === EAdenaResponseType.ALREADY_CONNECTED
        ) {
            // Adena establishes a connection if:
            // - the app was not connected before, and the user approves
            // - the app was connected before
            return;
        }

        // Unable to connect to the Adena wallet
        throw new Error('unable to establish connection');
    }

    // Fetches the currently selected account info
    static async getAccountInfo(): Promise<IAccountInfo> {
        await AdenaService.validateAdena();

        // This should be injected by the extension
        const adena = window.adena;

        // Get the account info
        if (!adena) {
            throw new Error('Adena is not defined');
        }
        const response: IAdenaResponse = await adena.GetAccount() as IAdenaResponse;
        if (response.status !== EAdenaResponseStatus.SUCCESS) {
            throw new Error('unable to fetch account info');
        }

        return response.data as IAccountInfo;
    }

    // Switches the Adena network to the given chain ID
    static async switchNetwork(chainID: string): Promise<void> {
        await AdenaService.validateAdena();

        //This should be injected by the extension
        const adena = window.adena;

        // Get the account info
        if (!adena) {
            throw new Error('Adena is not defined');
        }
        const response: IAdenaResponse = await adena.SwitchNetwork(chainID);
        if (
            response.status === EAdenaResponseStatus.SUCCESS ||
            response.type === EAdenaResponseType.REDUNDANT_CHANGE_REQUESTED
        ) {
            return;
        }

        throw new Error('unable to switch Adena network');
    }

    // Sends the given messages within a transaction
    // to the connected Gno chain through Adena
    static async sendTransaction(
        messages: IAdenaMessage[],
        gasWanted: number
    ): Promise<BroadcastTxCommitResult> {
        await AdenaService.validateAdena();

        //  This should be injected by the extension
        const adena = window.adena;

        // Ensure adena is defined
        if (!adena) {
            throw new Error('Adena is not defined');
        }

        // Sign and send the transaction
        const response: IAdenaResponse = await adena.DoContract({
            messages: messages,
            gasFee: 100000, // 0.1 gnot
            gasWanted: gasWanted // ugnot
        });

        // Check the response
        if (response.status !== EAdenaResponseStatus.SUCCESS) {
            throw new Error(`unable to send transaction: ${response.message}`);
        }

        // Parse the response output
        return response.data as BroadcastTxCommitResult;
    }
}
