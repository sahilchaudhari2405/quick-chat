const express = require('express');
const pool = require('../database/database-connection');
async function handleGetUser(req, res) {
    const { id } = req.params;
    console.log(id); // To verify the id parameter

    try {
        const result = await pool.query('SELECT user_id, email, name, bio, profile_picture,is_active FROM contacts WHERE user_id = $1', [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({ message: 'User not found' });
        }

        const user = result.rows[0];
        res.status(200).json(user);
    } catch (error) {
        console.error('Error retrieving user profile:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

module.exports = {
    handleGetUser
};