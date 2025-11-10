const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const helmet = require("helmet");
require("dotenv").config();

const app = express();

// Middleware
app.use(helmet());
app.use(cors({
  origin: "*",
  credentials: true,
  optionsSuccessStatus: 200,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"]
}));
app.use(express.json());
app.use(express.urlencoded({ limit: "10mb", extended: true }));

// MongoDB Connection
let isConnected = false;

const connectDB = async () => {
  if (isConnected) return;
  
  try {
    await mongoose.connect(
      process.env.MONGODB_URI || "mongodb://localhost:27017/safegirl-pro",
      {
        useNewUrlParser: true,
        useUnifiedTopology: true,
      }
    );
    isConnected = true;
    console.log("MongoDB connected successfully");
  } catch (err) {
    console.error("MongoDB connection failed:", err.message);
    throw err;
  }
};

// Initialize DB on first request
app.use(async (req, res, next) => {
  if (!isConnected) {
    try {
      await connectDB();
    } catch (err) {
      return res.status(500).json({ error: "Database connection failed" });
    }
  }
  next();
});

// Import Routes
const authRoutes = require("../routes/auth");
const userRoutes = require("../routes/user");
const guardianRoutes = require("../routes/guardian");
const emergencyRoutes = require("../routes/emergency");
const locationRoutes = require("../routes/location");

// Register Routes
app.use("/api/auth", authRoutes);
app.use("/api/user", userRoutes);
app.use("/api/guardian", guardianRoutes);
app.use("/api/emergency", emergencyRoutes);
app.use("/api/location", locationRoutes);

// Health Check
app.get("/api/health", (req, res) => {
  res.json({ 
    status: "Server is running", 
    timestamp: new Date(),
    database: isConnected ? "connected" : "disconnected"
  });
});

// Root endpoint
app.get("/", (req, res) => {
  res.json({ 
    message: "SafeGirl Pro API",
    version: "1.0.0",
    health: "/api/health"
  });
});

// Error Handling Middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    error: {
      message: err.message,
      status: err.status || 500,
    },
  });
});

// 404 Handler
app.use((req, res) => {
  res.status(404).json({ 
    error: "Route not found",
    path: req.path,
    method: req.method
  });
});

module.exports = app;
