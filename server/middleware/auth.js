 function generateAuthenticateToken(user)
 {
    const id=(user.email)? user.email:user.user_id;
    const token = jwt.sign(id, SECRET_KEY, { expiresIn: '1h' });
 }
 function authenticateToken(req, res, next) {
    const token = req.header('Authorization')?.split(' ')[1];
    if (!token) return res.sendStatus(401);
    jwt.verify(token, SECRET_KEY, (err, user) => {
        if (err) return res.sendStatus(403);
        req.user = user;
        next();
    });
}
module.exports={
    generateAuthenticateToken,
    authenticateToken
}