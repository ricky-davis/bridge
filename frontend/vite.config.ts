import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// In dev, proxy API + websocket to the Go backend.
export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy: {
      '/api': 'http://localhost:8080',
      '/ws': {
        target: 'ws://localhost:8080',
        ws: true,
      },
    },
  },
})
