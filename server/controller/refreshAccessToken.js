require('dotenv').config();
const jwt = require('jsonwebtoken');
const { pool } = require('../database/database-connection'); // Assuming you have a db module to import the pool from

async function handleRefreshToken(req, res) {
    try {
        const { refreshToken } = req.body;
        if (!refreshToken) {
            return res.status(400).json({ message: 'Refresh token is required' });
        }

        const decoded = jwt.verify(refreshToken, process.env.SECRET_KEY);
        const { rows } = await pool.query(
            'SELECT * FROM access WHERE user_id = $1 AND device_id = $2 AND token = $3',
            [decoded.userId, decoded.deviceId, refreshToken]
        );

        if (rows.length === 0) {
            return res.status(401).json({ message: 'Invalid refresh token' });
        }

        const newAccessToken = jwt.sign(
            { userId: decoded.userId, deviceId: decoded.deviceId },
            process.env.SECRET_KEY,
            { expiresIn: '10min' }
        );

        return res.status(200).json({ accessToken: newAccessToken });
    } catch (err) {
        console.error('Error refreshing access token:', err);
        return res.status(500).json({ message: 'Could not refresh access token' });
    }
}

module.exports = {
    handleRefreshToken
};
