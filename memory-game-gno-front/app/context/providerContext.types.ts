import { GnoWSProvider } from '@gnolang/gno-js-client';

export interface IProviderContext {
  provider: GnoWSProvider | null;

  setProvider: (provider: GnoWSProvider) => void;
}
