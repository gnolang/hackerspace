import fs from 'fs';
import path from 'path';
import axios from 'axios';
import { AdenaService } from '../adena/adena'; // Adjust this to the actual path of your Adena service
import Config from '../config';
import {parseImageResponse} from "@/app/parsers/parseImageResponse";
import {useContext} from "react";
import ProviderContext from "@/app/context/ProviderContext"; // Adjust if you have a config file

// Directory to store images
const imageDir = path.join(process.cwd(), 'resources/imgs');

// Ensure the image directory exists
if (!fs.existsSync(imageDir)) {
    fs.mkdirSync(imageDir, { recursive: true });
}

// Download and save an image locally
const downloadImage = async (url: string, filepath: string) => {
    const response = await axios({
        url,
        method: 'GET',
        responseType: 'stream',
    });

    response.data.pipe(fs.createWriteStream(filepath));
};

// Fetch image URLs from the smart contract using AdenaService
const fetchAndDownloadImages = async () => {
    const { provider } = useContext(ProviderContext);
    try {
        // Assuming you use provider.evaluateExpression to get image URLs
        await AdenaService.validateAdena();

        if(provider){
            const response: string = await provider.evaluateExpression(
                Config.REALM_PATH,
                `GetImages()` // Adjust this to the function in your smart contract
            );
            const imageUrls = parseImageResponse(response); // Parse response to get URLs
            console.log('Fetched image URLs:', imageUrls);

            // Download each image and store it locally
            for (const url of imageUrls) {
                const filename = path.basename(url); // Get the filename from the URL
                const filepath = path.join(imageDir, filename); // Set local path

                try {
                    await downloadImage(url, filepath); // Download and save the image locally
                    console.log(`Downloaded ${filename} successfully.`);
                } catch (error) {
                    console.error(`Failed to download ${filename}:`, error);
                }
            }
        }
    } catch (error) {
        console.error('Error fetching or downloading images:', error);
    }
};

// Run this function when the app starts
fetchAndDownloadImages().then(() => {
    console.log('All images have been downloaded.');
});
