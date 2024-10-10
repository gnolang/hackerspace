// context/GameModeContext.tsx
import React, { createContext, useContext, useState, ReactNode } from 'react';
import { IGameModeContext } from './gamemodeContext.types';

const GameModeContext = createContext<IGameModeContext>({
    gameMode: 'portal-loop',  // default mode
    setGameMode: () => {},
});

// Custom hook to access the context
export const useGameMode = () => useContext(GameModeContext);

// GameModeProvider component to wrap your app
export const GameModeProvider = ({ children }: { children: ReactNode }) => {
    const [gameMode, setGameMode] = useState<string>('portal-loop');

    return (
        <GameModeContext.Provider value={{ gameMode, setGameMode }}>
            {children}
        </GameModeContext.Provider>
    );
};
