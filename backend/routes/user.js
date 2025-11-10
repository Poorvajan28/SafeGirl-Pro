const express = require("express");
const User = require("../models/User");
const authenticate = require("../middleware/authenticate");

const router = express.Router();

// Get user profile
router.get("/profile", authenticate, async (req, res) => {
  try {
    const user = await User.findById(req.userId)
      .select("-password")
      .populate("emergencyContacts")
      .populate("guardians")
      .populate("safeZones");

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update user profile
router.put("/profile", authenticate, async (req, res) => {
  try {
    const { name, dob, gender, address, profilePhoto } = req.body;

    const user = await User.findByIdAndUpdate(
      req.userId,
      {
        name: name || undefined,
        dob: dob || undefined,
        gender: gender || undefined,
        address: address || undefined,
        profilePhoto: profilePhoto || undefined,
        updatedAt: new Date(),
      },
      { new: true, runValidators: true }
    ).select("-password");

    res.json({
      message: "Profile updated successfully",
      user,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update preferences
router.put("/preferences", authenticate, async (req, res) => {
  try {
    const {
      voiceCommandsEnabled,
      locationSharingEnabled,
      notificationsEnabled,
    } = req.body;

    const user = await User.findByIdAndUpdate(
      req.userId,
      {
        voiceCommandsEnabled:
          voiceCommandsEnabled !== undefined ? voiceCommandsEnabled : undefined,
        locationSharingEnabled:
          locationSharingEnabled !== undefined
            ? locationSharingEnabled
            : undefined,
        notificationsEnabled:
          notificationsEnabled !== undefined ? notificationsEnabled : undefined,
        updatedAt: new Date(),
      },
      { new: true }
    ).select("-password");

    res.json({
      message: "Preferences updated successfully",
      user,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
