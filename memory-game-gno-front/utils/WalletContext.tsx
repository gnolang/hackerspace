'use client';
import React, { createContext, useContext, useState, useEffect } from 'react';
import { AdenaSDK } from '@adena-wallet/sdk';

// Define the context type
interface WalletContextType {
    account: string | null;
    isConnected: boolean;
    connectWallet: () => Promise<void>;
    disconnectWallet: () => void; // Function to disconnect the wallet
}

// Create the context with default values
const WalletContext = createContext<WalletContextType | undefined>(undefined);

// Create a provider component
export const WalletProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [account, setAccount] = useState<string | null>(null);
    const [isConnected, setIsConnected] = useState(false);

    // Function to connect the wallet
    const connectWallet = async () => {
        try {
            const adena = AdenaSDK.createAdenaWallet();
            await adena.connectWallet();
            const isConnected = await adena.isConnected();
            if (isConnected.data) {
                setIsConnected(true); // Update to true if connected
                await adena.getAccount().then((account) => {
                    if (account.data) {
                        setAccount(account.data.address);
                    }
                });

            } else {
                setIsConnected(false);
            }
        } catch (error) {
            console.error('Error connecting to the wallet:', error);
        }
    };

    // Function to disconnect the wallet
    const disconnectWallet = () => {
        setAccount(null);
        setIsConnected(false);
    };

    // Provide wallet context values
    return (
        <WalletContext.Provider
            value={{ account, isConnected, connectWallet, disconnectWallet }}
        >
            {children}
        </WalletContext.Provider>
    );
};

// Custom hook to use the WalletContext
export const useWallet = () => {
    const context = useContext(WalletContext);
    if (context === undefined) {
        throw new Error('useWallet must be used within a WalletProvider');
    }
    return context;
};
