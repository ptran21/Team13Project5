const express = require("express");
const pool = require("../db");

const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const [rows] = await pool.execute(
      `SELECT
         c.id,
         c.name,
         c.section_id,
         s.name AS section_name
       FROM categories c
       JOIN sections s ON c.section_id = s.id
       ORDER BY s.id, c.id`,
    );

    return res.json({ categories: rows });
  } catch (error) {
    console.error("Database Error in /api/categories:", error);
    return res.status(500).json({ error: "Failed to fetch categories" });
  }
});

module.exports = router;
