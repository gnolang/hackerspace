import React, { createContext, useContext, useEffect, useState } from 'react';

// Define the type for your wallet context value
interface WalletContextType {
    connected: boolean;
    connectWallet: () => Promise<void>;
}

const WalletContext = createContext<WalletContextType | undefined>(undefined);

export const useWallet = () => {
    const context = useContext(WalletContext);
    if (!context) {
        throw new Error('useWallet must be used within a WalletProvider');
    }
    return context;
};

export const WalletProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [connected, setConnected] = useState(false);

    const connectWallet = async () => {
        if (window.adena) {
            // Call the method to establish connection with Adena wallet
            await window.adena.AddEstablish("Adena");
            setConnected(true);
        } else {
            window.open("https://adena.app/", "_blank"); // Prompt user to install Adena Wallet
        }
    };

    useEffect(() => {
        // Automatically try to connect to the wallet when the component mounts
        connectWallet();
    }, []);

    return (
        <WalletContext.Provider value={{ connected, connectWallet }}>
            {children}
        </WalletContext.Provider>
    );
};
