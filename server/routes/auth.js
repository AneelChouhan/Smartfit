const express = require("express"); 
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");

// SIGN UP
authRouter.post("/api/signup", async (req, res) => {
  const { name, email, password, number, type } = req.body;
  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      res.status(400).json({ msg: "User with same email already exist!" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);
    console.log(number);
    let user = new User({
      email,
      password: hashedPassword,
      name,
      number: number,
      type: type,
    });
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email doesnot exist!" });
    }
    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect Password." });
    }
    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/api/forgetpassword", async (req, res) => {
  try {
    const { email, password, id } = req.body;
    
    const user = await User.findById(id);
    
    const isMatch = await bcryptjs.compare(email, user.password);
    if (isMatch) {
      const newPassword = password;
      const hashedPassword = await bcryptjs.hash(newPassword, 8);

      const updatedUser = await User.findOneAndUpdate(
        { email },
        { $set: { password: hashedPassword } },
        { new: true } 
      );

      res.json({ msg: "Password reset successfully!" });
    } else {
      res.status(500).json({ error: "Cureent password is incorrect" });
    }

  } catch (e) {
    console.error(e); 
    res.status(500).json({ error: "Internal server error." });
  }
});


authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//get the user data
// authRouter.get("/", async (req, res) => {
//   const user = await User.findById(req.user);
//   res.json({ ...user._doc, token: req.token });
// });

module.exports = authRouter;
