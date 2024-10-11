// app/layout.tsx (or your RootLayout file)

'use client'

import localFont from "next/font/local";
import "./globals.css";
import { ToastContainer } from 'react-toastify';
import { useState} from "react";
import { GnoWSProvider} from "@gnolang/gno-js-client";
import Config from './config';
import AccountContext from './context/AccountContext';
import ProviderContext from './context/ProviderContext';
import Navbar from "@/app/components/Navbar";

const geistSans = localFont({
    src: "./fonts/GeistVF.woff",
    variable: "--font-geist-sans",
    weight: "100 900",
});
const geistMono = localFont({
    src: "./fonts/GeistMonoVF.woff",
    variable: "--font-geist-mono",
    weight: "100 900",
});

export default function RootLayout({children,}: Readonly<{
    children: React.ReactNode;
}>) {
    const [provider, setProvider] = useState<GnoWSProvider| null>(
        new GnoWSProvider(Config.CHAIN_RPC)
    );

    // Manage the state of user account (address and chainID)
    const [address, setAddress] = useState<string | null>(null);
    const [chainID, setChainID] = useState<string | null>(Config.CHAIN_ID);

    // Prepare values to pass to contexts
    const accountContextValue = {
        address,
        chainID,
        setAddress,
        setChainID,
    };

    const providerContextValue = {
        provider,
        setProvider,
    };

    return (
        <html lang="en">
        <body className={`${geistSans.variable} ${geistMono.variable} antialiased`}>
        <ProviderContext.Provider value={providerContextValue}>
            <AccountContext.Provider value={accountContextValue}>
                <Navbar />
                {children}
                <ToastContainer position="top-right" autoClose={5000} hideProgressBar={false} closeOnClick draggable pauseOnHover />
            </AccountContext.Provider>
        </ProviderContext.Provider>
        </body>
        </html>
    );
}
