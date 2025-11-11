const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const helmet = require("helmet");
require("dotenv").config();

const app = express();

// Middleware
app.use(helmet());
app.use(
  cors({
    origin: "*",
    credentials: true,
    optionsSuccessStatus: 200,
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);
app.use(express.json());
app.use(express.urlencoded({ limit: "10mb", extended: true }));

// MongoDB Connection
let isConnected = false;
let connectionError = null;

const connectDB = async () => {
  if (isConnected) return true;

  try {
    const mongoUri = process.env.MONGODB_URI;

    if (!mongoUri) {
      console.error("❌ MONGODB_URI environment variable not set!");
      connectionError = "MONGODB_URI not configured";
      return false;
    }

    console.log("🔄 Attempting MongoDB connection...");

    // Set connection options with aggressive timeouts
    const options = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 8000,
      socketTimeoutMS: 25000,
      connectTimeoutMS: 8000,
      family: 4, // Use IPv4
      maxPoolSize: 3,
      minPoolSize: 1,
    };

    const connection = await mongoose.connect(mongoUri, options);

    isConnected = true;
    connectionError = null;
    console.log("✅ MongoDB connected successfully");
    return true;
  } catch (err) {
    console.error("❌ MongoDB connection failed:", err.message);
    connectionError = err.message;
    isConnected = false;
    return false;
  }
};

// Try to connect on startup
connectDB().catch((err) => console.error("Startup connection error:", err));

// Middleware to retry connection on each request
app.use(async (req, res, next) => {
  if (!isConnected && !req.path.includes("/health")) {
    try {
      await connectDB();
    } catch (err) {
      console.log("Connection retry failed");
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

// Health Check - doesn't wait for DB
app.get("/api/health", (req, res) => {
  const mongoUri = process.env.MONGODB_URI ? "Configured" : "Not Set";
  res.json({
    status: "Server is running",
    timestamp: new Date(),
    database: isConnected ? "connected" : "disconnected",
    mongodbUri: mongoUri,
    error: connectionError || null,
    note: "Set MONGODB_URI in environment variables",
  });
});

// Root endpoint
app.get("/", (req, res) => {
  res.json({
    message: "SafeGirl Pro API",
    version: "1.0.0",
    health: "/api/health",
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
    method: req.method,
  });
});

module.exports = app;
