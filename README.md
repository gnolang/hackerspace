# Image Hunt

**Image Hunt** is an interactive image-guessing game where players compete to find a hidden target image on a grid. The game features a blockchain-integrated leaderboard for saving high scores, with the backend deployed on the Gno blockchain.

## How to Play

1. You will see a grid of images, and one of them is randomly selected as the target.
2. Click on any image to make a guess.
3. If your guess is incorrect, you will receive directional clues:
   - Clues will point you to move left, right, up, or down towards the target image.
4. Your score is calculated as the total number of images minus the number of guesses you’ve made.
5. You can save your score on-chain, and your score will appear on the leaderboard for others to see.

The game ends when:
- You find the target image.
- You use up all your available guesses.

## Features

- **Blockchain Integration**: Scores are saved on the Gno blockchain, and players can view a global leaderboard.
- **Directional Hints**: Players receive directional clues (up, down, left, right) to guide them to the target.
- **Score System**: Fewer guesses equal a higher score. The final score is the number of images minus the number of guesses.
- **Leaderboard**: Players can compare their high scores with others on the leaderboard stored on-chain.

## Technologies Used

- **Frontend**: Built using Next.js, React, and TypeScript (TSX).
- **Wallet Integration**: Uses the Adena wallet connection, adapted from the Memeland example from the Gno GitHub repository, to manage wallet connection and score saving.
- **Backend**: Deployed on the Gno blockchain at [`gno.land/r/matijamarjanovic/imageshunt`](https://gno.land/r/matijamarjanovic/imageshunt).

## Live Demo

You can play the game at [Image Hunt](https://matijamarjanovic.github.io/ImageHuntGno/).

## Requirements

To save your score on the blockchain, you must have the following:

- **Adena Wallet Extension**: Install the Adena wallet extension in your browser.
- **Account**: Create an account in the Adena wallet to manage your funds.
- **Gas Fees**: Ensure you have sufficient funds in your Adena wallet to cover the gas fees for saving your score on-chain.

## Installation and Running Locally

1. Clone the repository:
   ```bash
   git clone https://github.com/matijamarjanovic/ImageHuntGno.git
   cd imagehunt
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

4. Open the app in your browser at `http://localhost:3000`.

## Saving Your Score on the Blockchain

- Players must have the Adena wallet installed and connected to save their scores.
- After finishing the game, you will be prompted to save your score on-chain, and it will be reflected in the leaderboard.

## Contributing

If you’d like to contribute to the project, please fork the repository and create a pull request. Any contributions are welcome!
