/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['localhost'],
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'api.placeholder.com',
        port: '',
        pathname: '/**',
      },
    ],
  },
  experimental: {
    serverActions: true,
  },
  typescript: {
    ignoreBuildErrors: false,
  }
};

module.exports = nextConfig;