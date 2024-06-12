var jwt = require('jsonwebtoken');
require('dotenv').config()

function generateToken(user_id, device_id, expireTime) {
    return jwt.sign({ user_id, device_id }, process.env.SECRET_KEY, { expiresIn: expireTime });
  }
async function verifyToken(req, res, next) {
    try {
        const token = req.cookies?.accessToken || req.header("accessToken")?.replace("Bearer ", "")
        
        // console.log(token);
        if (!token) {
            throw new ApiError(401, "Unauthorized request")
        }
    
        jwt.verify(token,process.env.SECRET_KEY , (err, user) => {
            if (err) return res.sendStatus(403);
            req.user = user;
            next();
          });
    } catch (error) {
        throw new ApiError(401, error?.message || "Invalid access token")
    }
    
}
module.exports={
    verifyToken,
    generateToken,
}