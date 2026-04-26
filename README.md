# SE 4220 – Project 5
## Database Design & Data Population

---

## Overview

This task involves designing and populating a relational database for a cloud-based classified advertisement website. The database supports both visitor browsing and registered user listings.

The database is implemented using **MySQL (Google Cloud SQL)**.

---

## Database Information

- **Database Name:** classified_ads_db  
- **Tables:** sections, categories, listings, users  

---

## Database Structure

### sections
Stores the 5 main sections of the website.
- id (Primary Key)
- name

### categories
Stores categories under each section.
- id (Primary Key)
- section_id (Foreign Key → sections.id)
- name

### listings
Stores classified advertisement items.
- id (Primary Key)
- title
- category_id (Foreign Key → categories.id)
- user_id (Foreign Key → users.id)
- price
- description
- city
- phone
- condition_status
- posted_date

### users
Stores registered users.
- id (Primary Key)
- username
- email
- password

---

## Data Population Summary

- 5 sections
- 25 categories (5 per section)
- 75 listings (3 per category)

All requirements for initial data population have been satisfied.

---

## Setup Instructions

1. Open Cloud SQL Studio
2. Run:
```sql
CREATE DATABASE classified_ads_db;
USE classified_ads_db;
```
3. Execute:
database_seed.sql

## Verification Queries
-- Verify counts
SELECT COUNT(*) AS total_sections FROM sections;
SELECT COUNT(*) AS total_categories FROM categories;
SELECT COUNT(*) AS total_listings FROM listings;

-- Verify each category has 3 items
SELECT 
    categories.id AS category_id,
    categories.name AS category_name,
    COUNT(listings.id) AS total_items
FROM categories
LEFT JOIN listings ON categories.id = listings.category_id
GROUP BY categories.id, categories.name
ORDER BY categories.id;

## Example Query
SELECT 
    listings.title,
    categories.name AS category,
    sections.name AS section,
    listings.price
FROM listings
JOIN categories ON listings.category_id = categories.id
JOIN sections ON categories.section_id = sections.id;

---

## Backend API Module

An Express.js backend has been added to support:

- User registration and login (JWT authentication)
- Visitor access to browse all listings in read-only mode
- Authenticated listing creation for registered users

### Backend Setup

1. Install dependencies:

```bash
npm install
```

2. Create environment file:

- Copy `.env.example` to `.env`
- Update DB and JWT values

3. Start the API server:

```bash
npm start
```

Server default URL: `http://localhost:3000`

### API Endpoints

#### Health
- `GET /health`

#### Authentication
- `POST /api/auth/register`
    - Body: `username`, `email`, `password`
    - Returns: JWT token and created user

- `POST /api/auth/login`
    - Body: `email`, `password`
    - Returns: JWT token and user

#### Visitor Read-Only Access
- `GET /api/listings`
    - Public endpoint for visitors and registered users
    - Returns all listings with category, section, and seller data

- `GET /api/categories`
    - Public endpoint listing all supported categories

#### Registered User Listing Creation
- `POST /api/listings`
    - Requires header: `Authorization: Bearer <token>`
    - Required body fields:
        - `title`
        - `category_id`
        - `description`
        - `city`
        - `phone`
        - `condition_status`
    - Optional field: `price`

### Backend Files

- `src/server.js` - app entry point and route registration
- `src/routes/authRoutes.js` - register and login logic
- `src/routes/listingRoutes.js` - listing browse and create logic
- `src/routes/categoryRoutes.js` - category browse endpoint
- `src/middleware/auth.js` - JWT auth middleware
- `src/db.js` - MySQL connection pool

### Postman API Tests

Ready-to-import Postman assets are included in the `postman` folder:

- `postman/Team13Project5.postman_collection.json`
- `postman/Team13Project5.local.postman_environment.json`

#### What the collection tests

1. `GET /health`
2. `GET /api/categories` (visitor read-only access)
3. `GET /api/listings` (visitor read-only access)
4. `POST /api/auth/register` (creates unique test user)
5. `POST /api/auth/login`
6. `POST /api/listings` (authenticated listing creation)

#### Run Instructions

1. Start the backend server:

```bash
npm start
```

2. In Postman, import both files from the `postman` folder.
3. Select environment: `Team13 Local`.
4. Run the full collection in order.

The collection automatically stores the JWT token from register/login and uses it for listing creation.

