import { config } from '@lyriks/eslint-config/index.js';

export default [
  ...config,
  {
    ignores: ['.svelte-kit/**', 'dist/**']
  }
];
