const mysql = require('mysql2/promise');
const { DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME } = require('./config');

const connectionConfig = {
  user: DB_USER,
  password: DB_PASSWORD,
  database: DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

if (process.env.INSTANCE_CONNECTION_NAME) {
  connectionConfig.socketPath = `/cloudsql/${process.env.INSTANCE_CONNECTION_NAME}`;
} else {
  connectionConfig.host = DB_HOST;
  connectionConfig.port = Number(DB_PORT);
}

const pool = mysql.createPool(connectionConfig);

module.exports = pool;
