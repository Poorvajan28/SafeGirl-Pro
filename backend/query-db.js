const mongoose = require("mongoose");

const connectDB = async () => {
  try {
    await mongoose.connect("mongodb://localhost:27017/safegirl-pro", {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("✅ MongoDB Connected");

    // Get all users
    const db = mongoose.connection;
    const usersCollection = db.collection("users");
    const users = await usersCollection.find({}).toArray();

    console.log("\n📊 USERS IN DATABASE:");
    console.log("═══════════════════════════════════════════════════════════");
    if (users.length === 0) {
      console.log("No users found. Create one by registering in the app!");
    } else {
      users.forEach((user, index) => {
        console.log(`\nUser ${index + 1}:`);
        console.log(`  ID: ${user._id}`);
        console.log(`  Name: ${user.name}`);
        console.log(`  Email: ${user.email}`);
        console.log(`  Phone: ${user.phone}`);
        console.log(`  Created: ${user.createdAt}`);
      });
    }

    // Get all guardians
    const guardiansCollection = db.collection("guardians");
    const guardians = await guardiansCollection.find({}).toArray();

    console.log("\n📊 GUARDIANS IN DATABASE:");
    console.log("═══════════════════════════════════════════════════════════");
    if (guardians.length === 0) {
      console.log("No guardians found.");
    } else {
      guardians.forEach((guardian, index) => {
        console.log(`\nGuardian ${index + 1}:`);
        console.log(`  ID: ${guardian._id}`);
        console.log(`  Name: ${guardian.name}`);
        console.log(`  Phone: ${guardian.phone}`);
        console.log(`  Relationship: ${guardian.relationship}`);
        console.log(`  Priority: ${guardian.priority}`);
        console.log(`  Verified: ${guardian.isVerified}`);
      });
    }

    // Get all emergencies
    const emergenciesCollection = db.collection("emergencysessions");
    const emergencies = await emergenciesCollection.find({}).toArray();

    console.log("\n🚨 EMERGENCY SESSIONS IN DATABASE:");
    console.log("═══════════════════════════════════════════════════════════");
    if (emergencies.length === 0) {
      console.log("No emergency sessions found.");
    } else {
      emergencies.forEach((emergency, index) => {
        console.log(`\nEmergency ${index + 1}:`);
        console.log(`  ID: ${emergency._id}`);
        console.log(`  Status: ${emergency.status}`);
        console.log(
          `  Location: (${emergency.latitude}, ${emergency.longitude})`
        );
        console.log(`  Started: ${emergency.startedAt}`);
      });
    }

    // Get all locations
    const locationsCollection = db.collection("locationrecords");
    const locations = await locationsCollection.find({}).toArray();

    console.log("\n📍 LOCATION RECORDS IN DATABASE:");
    console.log("═══════════════════════════════════════════════════════════");
    if (locations.length === 0) {
      console.log("No location records found.");
    } else {
      console.log(`Total records: ${locations.length}`);
      console.log("\nLatest 5 locations:");
      locations.slice(-5).forEach((location, index) => {
        console.log(
          `  ${index + 1}. (${location.latitude}, ${location.longitude}) - ${
            location.timestamp
          }`
        );
      });
    }

    console.log(
      "\n═══════════════════════════════════════════════════════════"
    );
    console.log("✅ Query Complete\n");

    await mongoose.connection.close();
    process.exit(0);
  } catch (err) {
    console.error("❌ Error:", err.message);
    process.exit(1);
  }
};

connectDB();
