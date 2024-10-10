'use client'
import React, { useContext, useEffect, useState } from "react";
import AccountContext from "@/app/context/AccountContext";
import ProviderContext from "@/app/context/ProviderContext";
import Config from "@/app/config";
import { parseImageResponse } from "@/app/parsers/parseImageResponse";
import { AdenaService } from '@/app/adena/adena';
import { EMessageType } from "@/app/adena/adena.types";

export default function Home() {
    const { address } = useContext(AccountContext);
    const { provider } = useContext(ProviderContext);
    const [images, setImages] = useState<string[]>([]);
    const [error, setError] = useState<string | null>(null);
    const [targetIndex, setTargetIndex] = useState<number | null>(null);
    const [feedback, setFeedback] = useState<string | null>(null);
    const [score, setScore] = useState<number>(0);
    const [guessCount, setGuessCount] = useState<number>(0);
    const [showSaveButton, setShowSaveButton] = useState<boolean>(false);
    const [gameOver, setGameOver] = useState<boolean>(false); // Track if the game is over

    const resetGame = () => {
        setFeedback(null);
        setScore(0);
        setGuessCount(0);
        setTargetIndex(null);
        setShowSaveButton(false);
        setGameOver(false); // Reset gameOver state
        if (images.length > 0) {
            const randomIndex = Math.floor(Math.random() * images.length * 2);
            setTargetIndex(randomIndex);
        }
    };

    useEffect(() => {
        if (images.length > 0) {
            const randomIndex = Math.floor(Math.random() * images.length);
            setTargetIndex(randomIndex);
        }
    }, [images]);

    const compareImages = (selectedIndex: number) => {
        if (targetIndex === null || gameOver) return; // Prevent guesses if game is over

        setGuessCount(prevCount => prevCount + 1);

        if (selectedIndex === targetIndex) {
            setFeedback("Congratulations! You found the treasure!");
            const finalScore = images.length - guessCount; // Calculate score
            alert(`You won! Your score is: ${finalScore}`);
            setScore(finalScore);
            setShowSaveButton(true); // Show save score button
            setGameOver(true); // Set game as over
        } else {
            let directionFeedback = "";
            const cols = 5; // Assuming the grid has 5 columns

            const selectedColumn = selectedIndex % cols;
            const targetColumn = targetIndex % cols;
            const selectedRow = Math.floor(selectedIndex / cols);
            const targetRow = Math.floor(targetIndex / cols);

            if (selectedColumn < targetColumn) {
                directionFeedback += "The treasure is more to the right.\n";
            } else if (selectedColumn > targetColumn) {
                directionFeedback += "The treasure is more to the left.\n";
            }

            if (selectedRow < targetRow) {
                directionFeedback += "The treasure is further down.\n";
            } else if (selectedRow > targetRow) {
                directionFeedback += "The treasure is further up.\n";
            }

            setFeedback(directionFeedback);
        }
    };

    const fetchImages = async () => {
        try {
            if (provider) {
                const response: string = await provider.evaluateExpression(
                    Config.REALM_PATH,
                    `GetImages()`,
                );

                const images = parseImageResponse(response);
                setImages(images);
                resetGame();
            }
        } catch (error) {
            console.error('Error fetching images:', error);
            setError("Error fetching images.");
        }
    };

    useEffect(() => {
        fetchImages();
    }, []);

    const handleSaveScore = async () => {
        if (!address) {
            alert('Address not found.');
            return;
        }

        try {
            await AdenaService.sendTransaction(
                [
                    {
                        type: EMessageType.MSG_CALL,
                        value: {
                            caller: address,
                            send: '',
                            pkg_path: Config.REALM_PATH,
                            func: 'SetScore',
                            args: [address, score.toString()],
                        },
                    },
                ],
                2000000
            );

            alert('Score saved successfully!');
        } catch (error) {
            console.error('Error saving score:', error);
            alert('Failed to save score.');
        }
    };

    return (
        <div className="flex flex-col items-center justify-center min-h-screen p-8 bg-slate-800">
            <h1 className="text-3xl font-bold mb-6">Treasure Hunt Game</h1>

            <div className="flex space-x-4 mb-6">
                <button
                    onClick={resetGame}
                    className="bg-blue-500 text-white py-2 px-4 rounded hover:bg-blue-600 transition"
                >
                    Reset Game
                </button>

                {showSaveButton && (
                    <button
                        onClick={handleSaveScore}
                        className="bg-green-500 text-white py-2 px-4 rounded hover:bg-green-600 transition"
                    >
                        Save Score
                    </button>
                )}
            </div>

            {error && <div className="text-red-500 mb-4">{error}</div>}
            {feedback && <div className="text-yellow-400 mb-4">{feedback}</div>}

            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-4">
                {images.concat(images).map((url, index) => (
                    <div
                        key={index}
                        className="relative group border border-gray-300 rounded-lg overflow-hidden shadow-md max-w-[10rem] cursor-pointer"
                        onClick={() => compareImages(index)}
                    >
                        <img
                            src={url}
                            alt={`Image ${index + 1}`}
                            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
                            style={{ aspectRatio: "4 / 3" }}
                        />
                    </div>
                ))}
            </div>
        </div>
    );
}
