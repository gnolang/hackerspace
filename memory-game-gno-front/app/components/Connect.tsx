// components/Connect.tsx
import {useState, useContext, useEffect} from 'react';
import ProviderContext from '../context/ProviderContext';
import AccountContext from '../context/AccountContext';
import { AdenaService } from '../adena/adena';
import Config from '../config';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

const Connect = () => {
    const { provider } = useContext(ProviderContext);
    const { setChainID, setAddress } = useContext(AccountContext);
    const [isLoading, setIsLoading] = useState(false);
    const [buttonText, setButtonText] = useState('Connect Wallet');

    const handleWalletConnect = async () => {
        setIsLoading(true);

        try {
            await AdenaService.establishConnection('memory-game-gno');
            const accountInfo = await AdenaService.getAccountInfo();
            await AdenaService.switchNetwork(Config.CHAIN_ID);

            setAddress(accountInfo.address);
            setChainID(Config.CHAIN_ID);

            toast.success("Connected to Adena!");

            if (provider) {
                const response = await provider.evaluateExpression(
                    Config.REALM_PATH,
                    `GetSingleImage(0)`
                );
                console.log('Auction data:', response);
            }

        } catch (error) {
            console.error(error);
            toast.error("Unable to connect to Adena");
        } finally {
            setIsLoading(false);
        }
    };
    useEffect(() => {
        if(provider){
            setButtonText('Wallet Connected');
        }
    }, []);

    return (
        <div className="flex justify-center items-center">
            <button
                onClick={handleWalletConnect}
                className={`px-4 py-2 text-white bg-slate-800 hover:bg-blue-700 transition-all rounded-md ${
                    isLoading ? 'opacity-50 cursor-not-allowed' : ''
                }`}
            >
                {isLoading ? (
                    <span className="flex items-center">
            <svg className="animate-spin mr-2 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
            </svg>
            Connecting...
          </span>
                ) : (
                    <span className="flex items-center">
            {buttonText}
          </span>
                )}
            </button>
        </div>
    );
};

export default Connect;
