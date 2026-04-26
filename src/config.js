const dotenv = require("dotenv");

dotenv.config({ path: ".env.local" });

module.exports = {
  PORT: process.env.PORT || 3000,
  DB_HOST: process.env.DB_HOST || "127.0.0.1",
  DB_PORT: process.env.DB_PORT || 3306,
  DB_USER: process.env.DB_USER || "root",
  DB_PASSWORD: process.env.DB_PASSWORD || "",
  DB_NAME: process.env.DB_NAME || "classified_ads_db",
  JWT_SECRET: process.env.JWT_SECRET || "dev_only_secret_change_me",
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN || "1h",
};
