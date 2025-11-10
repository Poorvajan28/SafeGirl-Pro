const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const helmet = require("helmet");
require("dotenv").config();

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ limit: "10mb", extended: true }));

// MongoDB Connection
let isConnected = false;

const connectDB = async () => {
  if (isConnected) {
    console.log("MongoDB already connected");
    return;
  }

  try {
    const uri = process.env.MONGODB_URI || "mongodb://localhost:27017/safegirl-pro";
    console.log("Attempting to connect to MongoDB...");
    
    await mongoose.connect(uri, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    });
    
    isConnected = true;
    console.log("✅ MongoDB connected successfully");
  } catch (err) {
    console.error("⚠️ MongoDB connection failed:", err.message);
    isConnected = false;
    // Don't exit process - allow API to work without DB for now
  }
};

// Try to connect on startup, but don't block
connectDB().catch(err => console.error("Connection error:", err));

// Reconnect middleware
app.use(async (req, res, next) => {
  if (!isConnected) {
    try {
      await connectDB();
    } catch (err) {
      console.log("Retry connection failed");
    }
  }
  next();
});

// Import Routes
const authRoutes = require("./routes/auth");
const userRoutes = require("./routes/user");
const guardianRoutes = require("./routes/guardian");
const emergencyRoutes = require("./routes/emergency");
const locationRoutes = require("./routes/location");

// Register Routes
app.use("/api/auth", authRoutes);
app.use("/api/user", userRoutes);
app.use("/api/guardian", guardianRoutes);
app.use("/api/emergency", emergencyRoutes);
app.use("/api/location", locationRoutes);

// Health Check
app.get("/api/health", (req, res) => {
  res.json({ status: "Server is running", timestamp: new Date() });
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
  res.status(404).json({ error: "Route not found" });
});

// For Vercel serverless
module.exports = app;

// For local development
if (require.main === module) {
  const PORT = process.env.PORT || 5000;
  app.listen(PORT, () => {
    console.log(`SafeGirl Pro Backend running on port ${PORT}`);
  });
}
