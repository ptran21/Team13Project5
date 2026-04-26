const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.execute(
      `SELECT
         l.id,
         l.title,
         l.price,
         l.description,
         l.city,
         l.phone,
         l.condition_status,
         l.posted_date,
         c.id AS category_id,
         c.name AS category_name,
         s.id AS section_id,
         s.name AS section_name,
         u.id AS seller_id,
         u.username AS seller_username
       FROM listings l
       JOIN categories c ON l.category_id = c.id
       JOIN sections s ON c.section_id = s.id
       LEFT JOIN users u ON l.user_id = u.id
       ORDER BY l.posted_date DESC`
    );

    return res.json({ items: rows });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to fetch listings' });
  }
});

router.post('/', requireAuth, async (req, res) => {
  const {
    title,
    category_id: categoryId,
    price,
    description,
    city,
    phone,
    condition_status: conditionStatus
  } = req.body;

  if (!title || !categoryId || !description || !city || !phone || !conditionStatus) {
    return res.status(400).json({
      error: 'title, category_id, description, city, phone, and condition_status are required'
    });
  }

  try {
    const [categories] = await pool.execute('SELECT id FROM categories WHERE id = ? LIMIT 1', [categoryId]);

    if (categories.length === 0) {
      return res.status(400).json({ error: 'Invalid category_id' });
    }

    const normalizedPrice = price === undefined || price === null || price === '' ? null : Number(price);

    if (normalizedPrice !== null && Number.isNaN(normalizedPrice)) {
      return res.status(400).json({ error: 'price must be a valid number when provided' });
    }

    const [result] = await pool.execute(
      `INSERT INTO listings
       (title, category_id, user_id, price, description, city, phone, condition_status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        title,
        categoryId,
        req.user.userId,
        normalizedPrice,
        description,
        city,
        phone,
        conditionStatus
      ]
    );

    return res.status(201).json({
      message: 'Listing created successfully',
      listing_id: result.insertId
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to create listing' });
  }
});

module.exports = router;
