import { defineConfig } from "astro/config";
import tailwind from "@tailwindcss/vite";

export default defineConfig({
  output: "static",
  site: "https://witalijrapicki.cloud",

  vite: {
    plugins: [tailwind()],
  },
});
