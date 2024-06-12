const pool = require('../database/database-connection');
const path = require('path');
const fs = require('fs');

// Function to delete files
const deleteFile = (filePath) => {
  fs.unlink(filePath, (err) => {
    if (err) console.error(err);
  });
};

const handleUpdateUserInfo = async (req, res) => {
  const { user_id, email,user_name, bio } = req.body;
  console.log(req.body);
  const profilePicture = req.file ? `/uploads/profile/${req.file.filename}` : null;

  try {
    // Check if the user already exists
    const userResult = await pool.query('SELECT * FROM contacts WHERE user_id = $1', [user_id]);
    const userExists = userResult.rows.length > 0;

    if (userExists) {
      // Fetch the current profile picture
      const currentProfilePicture = userResult.rows[0]?.profile_picture;

      // If a new profile picture is uploaded, delete the old one
      if (profilePicture && currentProfilePicture) {
        deleteFile(path.join(__dirname, '..', currentProfilePicture));
      }

      const query = `
        UPDATE contacts 
        SET 
          email = COALESCE($1, email),
          name = COALESCE($2, user_name),
          bio = COALESCE($3, bio),
          profile_picture = COALESCE($4, profile_picture),
          updated_at = CURRENT_TIMESTAMP 
        WHERE user_id = $5
        RETURNING *`;

      const values = [email,user_name, bio, profilePicture, user_id];
      const result = await pool.query(query, values);
      res.json(result.rows[0]);
    } else {
      const query = `
        INSERT INTO contacts (user_id, email,name, bio, profile_picture, is_active)
        VALUES ($1, $2, $3, $4, $5, true)
        RETURNING *`;

      const values = [user_id, email, user_name, bio, profilePicture];
      const result = await pool.query(query, values);
      res.json(result.rows[0]);
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  handleUpdateUserInfo
};
