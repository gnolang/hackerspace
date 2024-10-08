'use client';
import React, { useContext, useEffect, useState } from "react";
import AccountContext from "@/app/context/AccountContext";
import ProviderContext from "@/app/context/ProviderContext";
import Config from "@/app/config";
import {parseImageResponse} from "@/app/parsers/parseImageResponse";

export default function Home() {
    const { address } = useContext(AccountContext);
    const { provider } = useContext(ProviderContext);
    const [images, setImages] = useState<string[]>([]);
    const [error, setError] = useState<string | null>(null);

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
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
                {images.map((url, index) => (
                    <div key={index} className="relative group border border-gray-300 rounded-lg overflow-hidden shadow-md max-w-[10rem]">
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
