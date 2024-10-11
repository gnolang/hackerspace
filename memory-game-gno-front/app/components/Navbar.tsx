'use client';
import React, { useState, useEffect } from 'react';
import Connect from './Connect';
import Link from "next/link";

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
            <Link href={"/"}>
                <div className="text-lg font-bold mr-6">Image Hunt</div>
            </Link>

            <div className="flex items-center space-x-4">
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
                                    Click on an image to guess if it&apos;s the target. If it&apos;s not, you&apos;ll receive a clue!
                                </p>
                                <p className="mb-2">
                                    The clue will point you in a direction (left, right, up, or down) towards the target image.
                                </p>
                                <p className="mb-2">
                                    You score points based on how quickly you find the target. Your score is calculated as the number of images minus the number of guesses.
                                </p>
                                <p className="mb-2">
                                    The game ends when the target image is found or when all guesses are used.
                                </p>
                                <p>
                                    You can save your score on the blockchain, and there&apos;s a leaderboard of the best scores!
                                </p>
                            </div>
                        </div>
                    )}
                </div>

                <Link href={"/leaderboard"}>
                    <button className="text-white focus:outline-none">Leaderboard</button>
                </Link>

                <div className="ml-auto">
                    <Connect />
                </div>
            </div>
        </nav>
    );
};

export default Navbar;
