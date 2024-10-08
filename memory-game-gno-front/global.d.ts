// global.d.ts
interface Adena {
    SwitchNetwork(chainID: string): import("./services/adena/adena.types").IAdenaResponse | PromiseLike<import("./services/adena/adena.types").IAdenaResponse>;
    AddEstablish(appName: string): Promise<{ code: number }>;
    GetAccount(): Promise<{ data: any }>;
    DoContract(contract: any): Promise<any>;
}

interface Window {
    adena?: Adena; // Optional chaining in case it's undefined
}
