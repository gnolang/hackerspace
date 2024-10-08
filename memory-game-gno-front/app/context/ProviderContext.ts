import { createContext } from 'react';
import { IProviderContext } from './providerContext.types';

const ProviderContext = createContext<IProviderContext>({
    provider: null,
    setProvider: () => {}
});

export default ProviderContext;
