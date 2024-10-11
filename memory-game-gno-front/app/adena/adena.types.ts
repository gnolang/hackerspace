import { MsgAddPackage, MsgCall, MsgSend } from '@gnolang/gno-js-client';
import { MsgRun } from '@gnolang/gno-js-client/bin/proto/gno/vm';

export enum EAdenaResponseStatus {
    SUCCESS = 'success',
    FAILURE = 'failure'
}

export enum EAdenaResponseType {
    ALREADY_CONNECTED = 'ALREADY_CONNECTED',
    REDUNDANT_CHANGE_REQUESTED = 'REDUNDANT_CHANGE_REQUEST'
}

export interface IAdenaResponse {
    code: number;
    status: EAdenaResponseStatus;
    type: EAdenaResponseType;
    message: string;
    data: null | unknown;
}

export enum EAccountStatus {
    ACTIVE = 'ACTIVE',
    INACTIVE = 'IN_ACTIVE'
}

export interface IPublicKeyInfo {
    '@type': string;
    value: string;
}

export interface IAccountInfo {
    accountNumber: string;
    address: string;
    coins: string;
    chainId: string;
    sequence: string;
    status: EAccountStatus;
    public_key: IPublicKeyInfo;
}

export interface INetworkSwitchInfo {
    chainId: string;
}

export enum EMessageType {
    MSG_SEND = '/bank.MsgSend',
    MSG_CALL = '/vm.m_call',
    MSG_ADD_PKG = '/vm.m_addpkg',
    MSG_RUN = '/vm.m_run'
}

export type TMessage = MsgAddPackage | MsgCall | MsgSend | MsgRun;

export interface IAdenaMessage {
    type: EMessageType;
    value: TMessage;
}

export interface IAdenaTransaction {
    messages: IAdenaMessage[];
    gasFee: number;
    gasWanted: number;
    memo?: string;
}
