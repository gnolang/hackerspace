// pages/_app.tsx

import React from 'react';
import { AppProps } from 'next/app';
import { WalletProvider } from '../utils/WalletContext'; // Adjust the path to your WalletContext

const MyApp: React.FC<AppProps> = ({ Component, pageProps }) => {
    return (
        <WalletProvider>
            <Component {...pageProps} />
        </WalletProvider>
    );
};

export default MyApp;
