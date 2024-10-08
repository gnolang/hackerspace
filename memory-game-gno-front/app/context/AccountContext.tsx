import { createContext } from 'react';
import { IAccountContext } from './accountContext.types';

const AccountContext = createContext<IAccountContext>({
    address: '',
    chainID: '',
    setAddress: () => {},
    setChainID: () => {}
});

export default AccountContext;
