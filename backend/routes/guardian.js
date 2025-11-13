const express = require("express");
const Guardian = require("../models/Guardian");
const User = require("../models/User");
const authenticate = require("../middleware/authenticate");

const router = express.Router();

// Add guardian
router.post("/add", authenticate, async (req, res) => {
  try {
    const { name, phone, email, relationship, priority } = req.body;

    // Check if max guardians reached
    const user = await User.findById(req.userId);
    if (user.guardians.length >= 3) {
      return res.status(400).json({ error: "Maximum 3 guardians allowed" });
    }

    const guardian = new Guardian({
      userId: req.userId,
      name,
      phone,
      email,
      relationship,
      priority: priority || 1,
    });

    await guardian.save();

    // Add to user's guardians list
    user.guardians.push(guardian._id);
    await user.save();

    res.status(201).json({
      message: "Guardian added successfully",
      guardian,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get all guardians
router.get("/list", authenticate, async (req, res) => {
  try {
    const guardians = await Guardian.find({ userId: req.userId }).sort({
      priority: 1,
    });
    res.json(guardians);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update guardian
router.put("/:id", authenticate, async (req, res) => {
  try {
    const { name, phone, email, relationship, priority } = req.body;

    const guardian = await Guardian.findByIdAndUpdate(
      req.params.id,
      {
        name: name || undefined,
        phone: phone || undefined,
        email: email || undefined,
        relationship: relationship || undefined,
        priority: priority || undefined,
        updatedAt: new Date(),
      },
      { new: true, runValidators: true }
    );

    if (!guardian) {
      return res.status(404).json({ error: "Guardian not found" });
    }

    res.json({
      message: "Guardian updated successfully",
      guardian,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete guardian
router.delete("/:id", authenticate, async (req, res) => {
  try {
    const guardian = await Guardian.findByIdAndDelete(req.params.id);

    if (!guardian) {
      return res.status(404).json({ error: "Guardian not found" });
    }

    // Remove from user's guardians list
    await User.findByIdAndUpdate(req.userId, {
      $pull: { guardians: req.params.id },
    });

    res.json({ message: "Guardian deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
