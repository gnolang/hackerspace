export interface IGameModeContext {
    gameMode: string;
    setGameMode: (mode: (prevMode: string) => (string)) => void;
}
