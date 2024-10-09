export const parseImageResponse = (response: string): string[] => {
    const regex = /\((.*?)string\)/;
    const match = response.match(regex);

    if (!match || match.length < 2) {
        throw new Error('Invalid response format');
    }

    const cleanedRespons = match[1].trim();
    const cleanedResponse = cleanedRespons.replaceAll('\"', '');

    if (!cleanedResponse) {
        console.log('No images found');
        return [];
    }

    const entries = cleanedResponse.split("`").filter(Boolean);

    const images: string[] = entries.map(entry => {

        if(entry.startsWith('http')) {
            return entry;
        }else {
            return ""
        }
    });
    const filteredArray: string[] = images.filter((str) => str.trim() !== "");

    return filteredArray;
};
