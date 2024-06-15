const pool = require('../database/database-connection');

async function AddNewContact(req, res) {
    const { user_id, name, profile_picture, bio } = req.body;
    const id = req.headers['id'];

    console.log(req.body);
    console.log(id);
    const currentTimestamp = new Date();

    try {
        // Check if the contact already exists
        const checkQuery = `SELECT 1 FROM user_contact WHERE user_id = $1 AND contact_id = $2`;
        const checkResult = await pool.query(checkQuery, [id, user_id]);

        if (checkResult.rows.length > 0) {
            return res.status(400).json({ message: 'Contact already exists in your contacts' });
        }

        // If the contact does not exist, proceed to add it
        await pool.query(
            `INSERT INTO user_contact (user_id, contact_id, name, bio, profile_picture, created_at, updated_at)
             VALUES ($1, $2, $3, $4, $5, $6, $6)`,
            [id, user_id, name, bio, profile_picture, currentTimestamp]
        );

        res.status(201).json({ message: 'Contact added successfully' });
    } catch (error) {
        console.error('Error adding contact:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

module.exports = {
    AddNewContact
};
