import { GnoWSProvider } from '@gnolang/gno-js-client';
import {JSONRPCProvider} from "@gnolang/tm2-js-client";

export interface IProviderContext {
  provider: JSONRPCProvider | null;

  setProvider: (provider: JSONRPCProvider) => void;
}
