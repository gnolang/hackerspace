'use client';
import React, { useState, useEffect } from 'react';
import Connect from './Connect';
import Link from "next/link"; // Adjust the path as necessary

const Navbar = () => {
    const [isDropdownOpen, setIsDropdownOpen] = useState(false);

    const toggleDropdown = () => {
        setIsDropdownOpen(prev => !prev);
    };

    // Close dropdown when clicking outside
    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            const dropdown = document.getElementById("how-to-play-dropdown");
            if (dropdown && !dropdown.contains(event.target as Node)) {
                setIsDropdownOpen(false);
            }
        };

        document.addEventListener("mousedown", handleClickOutside);
        return () => {
            document.removeEventListener("mousedown", handleClickOutside);
        };
    }, []);

    return (
        <nav className="flex justify-between items-center p-4 bg-slate-950 text-white">
            {/* Game Title */}
            <Link href={"/"}>
                <div className="text-lg font-bold mr-6">Image Hunt</div>
            </Link>

            {/* Button Group */}
            <div className="flex items-center space-x-4">
                {/* Dropdown for How to Play */}
                <div className="relative">
                    <button
                        className="text-white focus:outline-none"
                        onClick={toggleDropdown}
                    >
                        How to Play
                    </button>
                    {isDropdownOpen && (
                        <div id="how-to-play-dropdown" className="absolute right-0 mt-2 w-64 bg-white rounded-md shadow-lg z-20">
                            <div className="p-4 text-black">
                                <h2 className="text-lg font-bold mb-2">How to Play</h2>
                                <p className="mb-2">
                                    You will see some images arranged in a grid. One of these images is the target.
                                </p>
                                <p className="mb-2">
                                    Click on an image to guess if it’s the target. If it's not, you'll receive a clue!
                                </p>
                                <p className="mb-2">
                                    Clues will tell you if the target image is brighter, darker, or more colorful than your guess.
                                </p>
                                <p className="mb-2">
                                    You score points based on how quickly you find the target. Fewer guesses = higher score!
                                </p>
                                <p>
                                    The game ends when the target image is found or all guesses are used.
                                </p>
                            </div>
                        </div>
                    )}
                </div>

                <Link href={"/leaderboard"}>
                    <button className="text-white focus:outline-none">Leaderboard</button>
                </Link>

                {/* Wallet Connect Button on the Far Right */}
                <div className="ml-auto">
                    <Connect />
                </div>
            </div>
        </nav>
    );
};

export default Navbar;
