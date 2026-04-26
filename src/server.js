const express = require("express");
const path = require("path");
const authRoutes = require("./routes/authRoutes");
const listingRoutes = require("./routes/listingRoutes");
const categoryRoutes = require("./routes/categoryRoutes");
const { PORT } = require("./config");

const app = express();

app.use(express.json());

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

// use path.join and __dirname to safely locate the public folder
app.use(express.static(path.join(__dirname, "public")));

app.use("/api/auth", authRoutes);
app.use("/api/listings", listingRoutes);
app.use("/api/categories", categoryRoutes);

app.use((req, res) => {
  res.status(404).json({ error: "Route not found" });
});

app.listen(PORT, () => {
  console.log(`API server listening on port ${PORT}`);
});

const pool = require("./db");
pool
  .getConnection()
  .then(() => console.log("DATABASE CONNECTED PERFECTLY!"))
  .catch((err) => console.error("DATABASE ERROR:", err.message));

// const express = require("express");
// const authRoutes = require("./routes/authRoutes");
// const listingRoutes = require("./routes/listingRoutes");
// const categoryRoutes = require("./routes/categoryRoutes");
// const { PORT } = require("./config");

// const app = express();

// app.use(express.json());

// app.get("/health", (req, res) => {
//   res.json({ status: "ok" });
// });

// app.use("/api/auth", authRoutes);
// app.use("/api/listings", listingRoutes);
// app.use("/api/categories", categoryRoutes);

// app.use((req, res) => {
//   res.status(404).json({ error: "Route not found" });
// });

// app.listen(PORT, () => {
//   console.log(`API server listening on port ${PORT}`);
// });
