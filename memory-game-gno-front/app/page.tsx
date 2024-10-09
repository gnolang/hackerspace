'use client';
import React, { useContext, useEffect, useState } from "react";
import AccountContext from "@/app/context/AccountContext";
import ProviderContext from "@/app/context/ProviderContext";
import Config from "@/app/config";
import {parseImageResponse} from "@/app/parsers/parseImageResponse";
import {FastAverageColor} from "fast-average-color";
import Vibrant from "@vibrant/core";

export default function Home() {
    const { address } = useContext(AccountContext);
    const { provider } = useContext(ProviderContext);
    const [images, setImages] = useState<string[]>([]);
    const [error, setError] = useState<string | null>(null);
    const [targetImage, setTargetImage] = useState<string | null>(null);
    const [selectedImage, setSelectedImage] = useState<string | null>(null);
    const [feedback, setFeedback] = useState<string | null>(null);

    const fac = new FastAverageColor();

    //select a random image that is the "treasure"
    useEffect(() => {
        // Select a random target image when the page loads
        const randomImage = images[Math.floor(Math.random() * images.length)];
        console.log('Target image:', randomImage);
        setTargetImage(randomImage);
    }, [images]);

    const analyzeImage = async (imgSrc: string): Promise<{ brightness: string, dominantColor: string }> => {
        const img = new Image();
        img.crossOrigin = "Anonymous"; // To avoid CORS issues
        img.src = imgSrc;

        return new Promise((resolve, reject) => {
            img.onload = async () => {
                try {
                    // Get brightness using fast-average-color
                    const brightness = fac.getColor(img).value.toString();
                    console.log('Brightness:', brightness);

                    // Get dominant color using Vibrant
                    const palette = await Vibrant.from(imgSrc).getPalette();
                    const dominantColor = palette.Vibrant?.hex ?? "#000000"; // Fallback to black if no color found

                    resolve({ brightness, dominantColor });
                } catch (error) {
                    reject(error);
                }
            };
            img.onerror = reject;
        });
    };

    const compareImages = async (selectedSrc: string) => {
        if (!targetImage) return;

        try {
            const targetProps = await analyzeImage(targetImage);
            const selectedProps = await analyzeImage(selectedSrc);

            let comparisonFeedback = "";

            // Compare brightness
            if (selectedProps.brightness > targetProps.brightness) {
                comparisonFeedback += "The target image is darker.\n";
            } else {
                comparisonFeedback += "The target image is brighter.\n";
            }

            // Compare dominant colors
            if (selectedProps.dominantColor !== targetProps.dominantColor) {
                comparisonFeedback += `The target image contains more of a different color (target color: ${targetProps.dominantColor}).\n`;
            } else {
                comparisonFeedback += "The color of the target is similar to your guess.\n";
            }

            setFeedback(comparisonFeedback);
        } catch (error) {
            console.error('Error analyzing images:', error);
            setFeedback("Couldn't analyze the images.");
        }
    };

    const fetchImages = async () => {
        try {
            if (provider) {
                const response: string = await provider.evaluateExpression(
                    Config.REALM_PATH,
                    `GetImages()`, // Adjust this function to fetch your images
                );

                const images = parseImageResponse(response);
                setImages(images);
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
            <h1 className="text-3xl font-bold mb-6">Welcome to the Image Hunt Game</h1>
            {error && <div className="text-red-500 mb-4">{error}</div>}
            {feedback && <div className="text-yellow-400 mb-4">{feedback}</div>} {/* Display feedback */}
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
                {images.map((url, index) => (
                    <div
                        key={index}
                        className="relative group border border-gray-300 rounded-lg overflow-hidden shadow-md max-w-[10rem] cursor-pointer"
                        onClick={() => {
                            setSelectedImage(url); // Set selected image state
                            compareImages(url); // Compare the selected image with the target image
                        }}
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
        </div>
    );

}
