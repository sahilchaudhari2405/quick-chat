const express = require('express');
const pool = require('../database/database-connection');

async function handleOtherGetUsers(req, res) {
    const { id } = req.headers;
    console.log(id); // To verify the id parameter

    try {
        // Check if user exists in the user_contact table
        const result = await pool.query('SELECT contact_id, name, bio, profile_picture FROM user_contact WHERE user_id = $1', [id]);

        if (result.rows.length === 0) {
            // If no user found, assume new user
            return res.status(404).json({ message: 'User not found, assuming new user' });
        }

        // If user exists, return user data
        const user = result.rows;
        res.status(200).json(user);
    } catch (error) {
        console.error('Error retrieving user profile:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

module.exports = {
    handleOtherGetUsers,
};
