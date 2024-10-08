'use client';
import React, { useEffect, useState } from 'react';
import { AdenaService } from '../adena/adena'; // Adjust the path as necessary
import { BroadcastTxCommitResult } from '@gnolang/tm2-js-client';
import {IAdenaMessage} from "@/app/adena/adena.types";

interface Score {
    address: string;
    points: number;
}

const Leaderboard: React.FC = () => {
    const [topScores, setTopScores] = useState<Score[]>([]);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const fetchTopScores = async () => {
            try {
                // Fetch top scores from the contract (mocking the fetch for now)
                const scores: Score[] = await getTopScores(); // Replace with your actual fetching logic
                setTopScores(scores);
            } catch (err) {
                console.error("Failed to fetch top scores:", err);
                setError("Error fetching top scores.");
            }
        };

        fetchTopScores();
    }, []);

    const sendTransaction = async () => {
        try {
            // Replace with your actual messages and gasWanted
            const messages : any[] = [];

            const gasWanted = 1000000; // Example gas wanted

            const result: BroadcastTxCommitResult = await AdenaService.sendTransaction(messages, gasWanted);
            console.log("Transaction successful:", result);
        } catch (error) {
            console.error("Failed to send transaction:", error);
            setError("Error sending transaction.");
        }
    };

    // Mock function to simulate fetching top scores
    const getTopScores = async (): Promise<Score[]> => {
        // In a real application, fetch this data from your smart contract
        return [
            { address: '0x123...', points: 100 },
            { address: '0x456...', points: 90 },
            { address: '0x789...', points: 80 },
            { address: '0xabc...', points: 70 },
            { address: '0xdef...', points: 60 },
        ];
    };

    useEffect(() => {
        sendTransaction(); // Send transaction when the component mounts
    }, []);

    return (
        <div className="p-4">
            <h1 className="text-2xl font-bold mb-4">Leaderboard</h1>
            {error && <div className="text-red-500">{error}</div>}
            <table className="min-w-full border-collapse border border-gray-800 text-center font-sans">
                <thead className="bg-gray-800 text-white">
                <tr>
                    <th className="border border-gray-600 px-4 py-2">Rank</th>
                    <th className="border border-gray-600 px-4 py-2">Address</th>
                    <th className="border border-gray-600 px-4 py-2">Points</th>
                </tr>
                </thead>
                <tbody>
                {topScores.map((score, index) => (
                    <tr key={index} className="border border-gray-600">
                        <td className="border border-gray-600 px-4 py-2">{index + 1}</td>
                        <td className="border border-gray-600 px-4 py-2 break-words max-w-xs">
                            {score.address}
                        </td>
                        <td className="border border-gray-600 px-4 py-2">{score.points}</td>
                    </tr>
                ))}
                </tbody>
            </table>
        </div>
    );
};

export default Leaderboard;
