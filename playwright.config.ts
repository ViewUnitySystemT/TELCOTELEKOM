import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  use: {
    baseURL: 'http://localhost:8080',
    headless: true,
    viewport: { width: 1280, height: 800 },
    actionTimeout: 30000,
    navigationTimeout: 30000,
  },
  timeout: 120000,
  expect: {
    timeout: 10000,
  },
  reporter: [['list']],
  retries: 2,
  workers: 1,
});


