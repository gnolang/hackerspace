import { ITopScore } from "@/app/leaderboard/topScore.types";

export const parseTopScores = (response: string): ITopScore[] => {
    const regex = /\((.*?)string\)/;
    const match = response.match(regex);

    if (!match || match.length < 2) {
        throw new Error('Invalid response format');
    }

    const cleanedResponse = match[1].trim();
    const cR = cleanedResponse.replaceAll('\"', '');

    if (!cR) {
        console.log('No top scores found');
        return [];
    }

    const entries = cR.split(";").filter(Boolean);
    console.log('Entries:', entries);

    const topScores: ITopScore[] = entries.map(entry => {
        const [rank, address, points] = entry.split(",");

        if (!rank || !address || !points) {
            throw new Error(`Invalid entry format: ${entry}`);
        }

        return {
            rank: parseInt(rank.trim(), 10),
            address: address.trim(),
            points: parseInt(points.trim(), 10)
        };
    });

    return topScores;
};
