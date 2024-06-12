const dbClient = require('../database/database-connection'); // Make sure to adjust the path to where your dbClient is defined

async function handleLogout(req, res) {
  const { user_id, device_id} = req.body;
  console.log('user'+user_id);
  try {
    // Deleting the device from the devices table
    await dbClient.query(
      'DELETE FROM access WHERE user_id=$1 AND device_id=$2',
      [user_id, device_id]
    );
    await dbClient.query(
      'UPDATE devices SET isactive=false WHERE user_id=$1 AND device_id=$2',
      [user_id, device_id]
    );

    // Optionally, you can log this action or perform additional operations if needed
    res.status(200).json({ message: "Logout successful" });
  } catch (error) {
    console.error('Error during logout:', error);
    res.status(400).send(error.message);
  }
}

module.exports = {
  handleLogout,
};
