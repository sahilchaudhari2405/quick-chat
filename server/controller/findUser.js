const express = require('express');
const pool = require('../database/database-connection');


async function handleFindUser(req, res) {
    const { id } = req.params;
    console.log(id); // To verify the id parameter

    try {
        const result = await pool.query(
            'SELECT user_id, email, name, bio, profile_picture FROM contacts WHERE user_id ILIKE $1',
            [`%${id}%`]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ message: 'User not found' });
        }

        const users = result.rows;
        res.status(200).json(users);
    } catch (error) {
        console.error('Error retrieving user profile:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

module.exports = {
    handleFindUser,
};
