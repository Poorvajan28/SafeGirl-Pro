const express = require("express");
const jwt = require("jsonwebtoken");
const { body, validationResult } = require("express-validator");
const User = require("../models/User");
const authenticate = require("../middleware/authenticate");

const router = express.Router();

// Register
router.post(
  "/register",
  [
    body("name").notEmpty().withMessage("Name is required"),
    body("email").isEmail().withMessage("Valid email is required"),
    body("phone").notEmpty().withMessage("Phone number is required"),
    body("pin")
      .optional()
      .isLength({ min: 4, max: 4 })
      .withMessage("PIN must be 4 digits"),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const { name, email, phone, pin, useBiometric } = req.body;

      // Check if user already exists
      const existingUser = await User.findOne({ $or: [{ email }, { phone }] });
      if (existingUser) {
        return res
          .status(400)
          .json({ error: "User already exists with this email or phone" });
      }

      // Create new user
      const user = new User({
        name,
        email,
        phone,
        pin: pin || "0000", // Default PIN if not provided
        useBiometric: useBiometric || false,
      });
      await user.save();

      // Generate JWT token
      const token = jwt.sign(
        { userId: user._id },
        process.env.JWT_SECRET ||
          "your_jwt_secret_key_change_this_in_production",
        { expiresIn: process.env.JWT_EXPIRE || "7d" }
      );

      res.status(201).json({
        message: "User registered successfully",
        token,
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          pin: user.pin,
          useBiometric: user.useBiometric,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
        },
      });
    } catch (err) {
      console.error("Registration error:", err);
      res.status(500).json({ error: err.message });
    }
  }
);

// Login
router.post(
  "/login",
  [
    body("email").isEmail().withMessage("Valid email is required"),
    body("pin").notEmpty().withMessage("PIN is required"),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const { email, pin } = req.body;

      // Find user
      const user = await User.findOne({ email });
      if (!user) {
        return res.status(400).json({ error: "Invalid email or PIN" });
      }

      // Check PIN
      if (user.pin !== pin) {
        return res.status(400).json({ error: "Invalid email or PIN" });
      }

      // Generate JWT token
      const token = jwt.sign(
        { userId: user._id },
        process.env.JWT_SECRET ||
          "your_jwt_secret_key_change_this_in_production",
        { expiresIn: process.env.JWT_EXPIRE || "7d" }
      );

      res.json({
        message: "Login successful",
        token,
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          pin: user.pin,
          useBiometric: user.useBiometric,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
        },
      });
    } catch (err) {
      console.error("Login error:", err);
      res.status(500).json({ error: err.message });
    }
  }
);

// Verify Token
router.get("/verify", authenticate, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select("-password");
    res.json({ valid: true, user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
