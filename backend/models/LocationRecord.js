const mongoose = require("mongoose");

const locationRecordSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  latitude: {
    type: Number,
    required: true,
  },
  longitude: {
    type: Number,
    required: true,
  },
  accuracy: {
    type: Number,
  },
  address: {
    type: String,
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
});

// Create geospatial index for location queries
locationRecordSchema.index({ location: "2dsphere" });

module.exports = mongoose.model("LocationRecord", locationRecordSchema);
