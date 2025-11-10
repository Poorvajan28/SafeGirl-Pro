const express = require("express");
const EmergencySession = require("../models/EmergencySession");
const Guardian = require("../models/Guardian");
const authenticate = require("../middleware/authenticate");

const router = express.Router();

// Trigger emergency
router.post("/trigger", authenticate, async (req, res) => {
  try {
    const { latitude, longitude, location, description } = req.body;

    const emergencySession = new EmergencySession({
      userId: req.userId,
      latitude,
      longitude,
      location,
      description,
      status: "active",
    });

    await emergencySession.save();

    // Get user's guardians
    const guardians = await Guardian.find({ userId: req.userId }).sort({
      priority: 1,
    });

    // In production, send notifications to guardians here
    // This would involve sending SMS, calls, or push notifications

    res.status(201).json({
      message: "Emergency triggered successfully",
      emergency: emergencySession,
      guardiansNotified: guardians.length,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get emergency history
router.get("/history", authenticate, async (req, res) => {
  try {
    const emergencies = await EmergencySession.find({ userId: req.userId })
      .populate("notifiedGuardians", "name phone")
      .sort({ startedAt: -1 });

    res.json(emergencies);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get active emergency
router.get("/active", authenticate, async (req, res) => {
  try {
    const activeEmergency = await EmergencySession.findOne({
      userId: req.userId,
      status: "active",
    }).populate("notifiedGuardians", "name phone");

    res.json(activeEmergency || { message: "No active emergency" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Resolve emergency
router.put("/:id/resolve", authenticate, async (req, res) => {
  try {
    const emergency = await EmergencySession.findByIdAndUpdate(
      req.params.id,
      {
        status: "resolved",
        endedAt: new Date(),
        updatedAt: new Date(),
      },
      { new: true }
    );

    if (!emergency) {
      return res.status(404).json({ error: "Emergency not found" });
    }

    res.json({
      message: "Emergency resolved successfully",
      emergency,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Cancel emergency
router.put("/:id/cancel", authenticate, async (req, res) => {
  try {
    const emergency = await EmergencySession.findByIdAndUpdate(
      req.params.id,
      {
        status: "cancelled",
        endedAt: new Date(),
        updatedAt: new Date(),
      },
      { new: true }
    );

    if (!emergency) {
      return res.status(404).json({ error: "Emergency not found" });
    }

    res.json({
      message: "Emergency cancelled successfully",
      emergency,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
