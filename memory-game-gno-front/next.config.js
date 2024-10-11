/** @type {import('next').NextConfig} */
const isProd = process.env.NODE_ENV === 'production';

const nextConfig = {
  reactStrictMode: true,
  images: {
    unoptimized: true, // Disable default image optimization
  },
  assetPrefix: isProd ? '/ImageHuntGno' : '',
  basePath: isProd ? '/ImageHuntGno' : '',
  output: 'export'
};

module.exports = nextConfig; // Use CommonJS syntax instead of ES module syntax
