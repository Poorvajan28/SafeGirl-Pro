const mongoose = require("mongoose");

const safeZoneSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  description: {
    type: String,
  },
  latitude: {
    type: Number,
    required: true,
  },
  longitude: {
    type: Number,
    required: true,
  },
  radius: {
    type: Number,
    default: 500,
    description: "Radius in meters",
  },
  color: {
    type: String,
    default: "#4CAF50",
  },
  notifyOnEntry: {
    type: Boolean,
    default: true,
  },
  notifyOnExit: {
    type: Boolean,
    default: true,
  },
  isActive: {
    type: Boolean,
    default: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("SafeZone", safeZoneSchema);
