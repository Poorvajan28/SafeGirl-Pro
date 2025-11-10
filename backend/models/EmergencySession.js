const mongoose = require("mongoose");

const emergencySessionSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  status: {
    type: String,
    enum: ["active", "resolved", "cancelled"],
    default: "active",
  },
  latitude: {
    type: Number,
    required: true,
  },
  longitude: {
    type: Number,
    required: true,
  },
  location: {
    type: String,
  },
  notifiedGuardians: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Guardian",
    },
  ],
  policeNotified: {
    type: Boolean,
    default: false,
  },
  description: {
    type: String,
  },
  audioRecording: {
    type: String,
  },
  startedAt: {
    type: Date,
    default: Date.now,
  },
  endedAt: {
    type: Date,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("EmergencySession", emergencySessionSchema);
