'use client';
import React, { useContext, useEffect, useState } from "react";
import AccountContext from "@/app/context/AccountContext";
import ProviderContext from "@/app/context/ProviderContext";
import Config from "@/app/config";
import { parseImageResponse } from "@/app/parsers/parseImageResponse";

export default function Home() {
    const { address } = useContext(AccountContext);
    const { provider } = useContext(ProviderContext);
    const [images, setImages] = useState<string[]>([]);
    const [error, setError] = useState<string | null>(null);
    const [targetIndex, setTargetIndex] = useState<number | null>(null); // Store the index of the treasure image
    const [feedback, setFeedback] = useState<string | null>(null);
    const [score, setScore] = useState<number>(0); // Track player's score
    const [guessCount, setGuessCount] = useState<number>(0); // Track number of guesses

    // Function to reset the game state
    const resetGame = () => {
        setFeedback(null);
        setScore(0);
        setGuessCount(0);
        setTargetIndex(null); // Reset target index to null to force recalculation
        if (images.length > 0) {
            const randomIndex = Math.floor(Math.random() * images.length *2);
            console.log('New target image index:', randomIndex);
            setTargetIndex(randomIndex); // Set a new target index for the new game
        }
    };

    // Select a random image that is the "treasure"
    useEffect(() => {
        if (images.length > 0) {
            const randomIndex = Math.floor(Math.random() * images.length);
            console.log('Target image index:', randomIndex);
            setTargetIndex(randomIndex);
        }
    }, [images]);

    // Compare selected image index with target and provide directional feedback
    const compareImages = (selectedIndex: number) => {
        if (targetIndex === null) return;

        setGuessCount(prevCount => prevCount + 1); // Increment guess count

        if (selectedIndex === targetIndex) {
            setFeedback("Congratulations! You found the treasure!");
            const finalScore = (images.length * 5) - guessCount; // Calculate score
            alert(`You won! Your score is: ${finalScore}`);
            setScore(finalScore);
        } else {
            let directionFeedback = "";
            if (selectedIndex < targetIndex) {
                directionFeedback += "The treasure is more to the right.\n";
            } else if (selectedIndex > targetIndex) {
                directionFeedback += "The treasure is more to the left.\n";
            }

            // Assuming a grid layout for rows, calculate if it's above or below
            const cols = 5; // Increased the number of columns to 5
            const selectedRow = Math.floor(selectedIndex / cols);
            const targetRow = Math.floor(targetIndex / cols);

            if (selectedRow < targetRow) {
                directionFeedback += "The treasure is further down.\n";
            } else if (selectedRow > targetRow) {
                directionFeedback += "The treasure is further up.\n";
            }

            setFeedback(directionFeedback);
        }
    };

    // Fetch images from smart contract (already provided)
    const fetchImages = async () => {
        try {
            if (provider) {
                const response: string = await provider.evaluateExpression(
                    Config.REALM_PATH,
                    `GetImages()`, // Adjust this function to fetch your images
                );

                const images = parseImageResponse(response);
                setImages(images);
                resetGame(); // Start a new game once images are fetched
            }
        } catch (error) {
            console.error('Error fetching images:', error);
            setError("Error fetching images.");
        }
    };

    useEffect(() => {
        fetchImages(); // Fetch images when the component mounts
    }, []);

    return (
        <div className="flex flex-col items-center justify-center min-h-screen p-8 bg-slate-800">
            <h1 className="text-3xl font-bold mb-6">Treasure Hunt Game</h1>
            {error && <div className="text-red-500 mb-4">{error}</div>}
            {feedback && <div className="text-yellow-400 mb-4">{feedback}</div>} {/* Display feedback */}
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-4"> {/* Increased grid columns to 5 */}
                {images.concat(images).map((url, index) => ( // Display each image twice
                    <div
                        key={index}
                        className="relative group border border-gray-300 rounded-lg overflow-hidden shadow-md max-w-[10rem] cursor-pointer"
                        onClick={() => compareImages(index)} // Pass index to compare with the target
                    >
                        <img
                            src={url}
                            alt={`Image ${index + 1}`}
                            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
                            style={{ aspectRatio: "4 / 3" }} // Keeps uniformity
                        />
                    </div>
                ))}
            </div>
            <button
                onClick={resetGame}
                className="mt-6 bg-blue-500 text-white py-2 px-4 rounded hover:bg-blue-600 transition"
            >
                Reset Game
            </button>
        </div>
    );
}
