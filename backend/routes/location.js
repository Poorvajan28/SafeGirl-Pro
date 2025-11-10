const express = require("express");
const LocationRecord = require("../models/LocationRecord");
const authenticate = require("../middleware/authenticate");

const router = express.Router();

// Save location
router.post("/save", authenticate, async (req, res) => {
  try {
    const { latitude, longitude, accuracy, address } = req.body;

    const locationRecord = new LocationRecord({
      userId: req.userId,
      latitude,
      longitude,
      accuracy,
      address,
    });

    await locationRecord.save();

    res.status(201).json({
      message: "Location saved successfully",
      location: locationRecord,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get location history
router.get("/history", authenticate, async (req, res) => {
  try {
    const { limit = 50, offset = 0 } = req.query;

    const locations = await LocationRecord.find({ userId: req.userId })
      .sort({ timestamp: -1 })
      .limit(parseInt(limit))
      .skip(parseInt(offset));

    const total = await LocationRecord.countDocuments({ userId: req.userId });

    res.json({
      locations,
      total,
      limit: parseInt(limit),
      offset: parseInt(offset),
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get last location
router.get("/last", authenticate, async (req, res) => {
  try {
    const lastLocation = await LocationRecord.findOne({
      userId: req.userId,
    }).sort({ timestamp: -1 });

    res.json(lastLocation || { message: "No location history" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get locations in date range
router.get("/range", authenticate, async (req, res) => {
  try {
    const { startDate, endDate } = req.query;

    const locations = await LocationRecord.find({
      userId: req.userId,
      timestamp: {
        $gte: new Date(startDate),
        $lte: new Date(endDate),
      },
    }).sort({ timestamp: -1 });

    res.json(locations);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
