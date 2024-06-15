const express = require('express');
const pool = require('../database/database-connection'); // Ensure this points to your database connection module

async function handleFindUser(req, res) {
    const { name, id } = req.headers; // Extract 'name' and 'id' from request headers
     console.log(req.headers);
    try {
        const result = await pool.query(
            'SELECT c.user_id, c.email, c.name AS name, c.bio, c.profile_picture ' +
            'FROM contacts c ' +
            'WHERE c.user_id != $1 AND (c.user_id LIKE $2 OR c.name LIKE $2)',
            [id, `%${name}%`]
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
