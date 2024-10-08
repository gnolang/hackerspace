export interface IAccountContext {
    address: string | null;
    chainID: string | null;

    setAddress: (address: string) => void;
    setChainID: (chainID: string) => void;
}
