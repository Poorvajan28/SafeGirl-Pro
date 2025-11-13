const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
  },
  phone: {
    type: String,
    required: true,
    unique: true,
  },
  pin: {
    type: String,
    required: false,
    default: "0000",
  },
  useBiometric: {
    type: Boolean,
    default: false,
  },
  password: {
    type: String,
    required: false,
  },
  dob: {
    type: Date,
  },
  gender: {
    type: String,
    enum: ["Male", "Female", "Other"],
  },
  address: {
    type: String,
  },
  profilePhoto: {
    type: String,
  },
  emergencyContacts: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "EmergencyContact",
    },
  ],
  guardians: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Guardian",
    },
  ],
  safeZones: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "SafeZone",
    },
  ],
  voiceCommandsEnabled: {
    type: Boolean,
    default: false,
  },
  locationSharingEnabled: {
    type: Boolean,
    default: false,
  },
  notificationsEnabled: {
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

// Hash password before saving (optional for backward compatibility)
userSchema.pre("save", async function (next) {
  if (!this.isModified("password") || !this.password) return next();

  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (err) {
    next(err);
  }
});

// Compare password method
userSchema.methods.comparePassword = async function (password) {
  return await bcrypt.compare(password, this.password);
};

module.exports = mongoose.model("User", userSchema);
