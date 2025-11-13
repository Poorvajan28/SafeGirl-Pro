# SafeGirl Pro - Backend Setup Guide

## Project Overview

SafeGirl Pro is a comprehensive personal safety application with a Node.js/Express backend and MongoDB database for production deployment.

## Prerequisites

- Node.js (v14 or higher)
- MongoDB (local or cloud instance like MongoDB Atlas)
- npm or yarn

## Installation Steps

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Configure Environment Variables

Create a `.env` file in the backend directory with the following:

```
# MongoDB Configuration
MONGODB_URI=mongodb://localhost:27017/safegirl-pro
# OR for MongoDB Atlas:
# MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/safegirl-pro

# Server Configuration
PORT=5000
NODE_ENV=development

# JWT Configuration
JWT_SECRET=your_very_secure_secret_key_change_this_in_production
JWT_EXPIRE=7d

# Frontend URL (for CORS)
FRONTEND_URL=http://localhost:8080
```

### 3. Start MongoDB

If using local MongoDB:

```bash
# On Windows
mongod

# On macOS
brew services start mongodb-community

# On Linux
sudo systemctl start mongod
```

Or use MongoDB Atlas (Cloud):

- Create a cluster at https://www.mongodb.com/cloud/atlas
- Update MONGODB_URI in .env with your connection string

### 4. Start the Backend Server

Development mode (with auto-reload):

```bash
npm run dev
```

Production mode:

```bash
npm start
```

The server will start on `http://localhost:5000`

## API Endpoints

### Authentication

- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/verify` - Verify token

### User Management

- `GET /api/user/profile` - Get user profile
- `PUT /api/user/profile` - Update user profile
- `PUT /api/user/preferences` - Update user preferences

### Guardian Management

- `POST /api/guardian/add` - Add guardian
- `GET /api/guardian/list` - Get all guardians
- `PUT /api/guardian/:id` - Update guardian
- `DELETE /api/guardian/:id` - Delete guardian

### Emergency Management

- `POST /api/emergency/trigger` - Trigger emergency
- `GET /api/emergency/history` - Get emergency history
- `GET /api/emergency/active` - Get active emergency
- `PUT /api/emergency/:id/resolve` - Resolve emergency
- `PUT /api/emergency/:id/cancel` - Cancel emergency

### Location Management

- `POST /api/location/save` - Save location
- `GET /api/location/history` - Get location history
- `GET /api/location/last` - Get last location
- `GET /api/location/range` - Get locations in date range

## Database Models

### User

- name, email, phone, password
- dob, gender, address, profilePhoto
- emergencyContacts, guardians, safeZones
- voiceCommandsEnabled, locationSharingEnabled, notificationsEnabled

### Guardian

- userId, name, phone, email, relationship
- priority (1-3), isVerified, lastNotified

### EmergencySession

- userId, status (active/resolved/cancelled)
- latitude, longitude, location, description
- notifiedGuardians, policeNotified, audioRecording

### LocationRecord

- userId, latitude, longitude, accuracy, address, timestamp

## Deployment

### Deploy to Heroku

1. Create Heroku account and install CLI
2. Create MongoDB Atlas cluster
3. Update .env with MongoDB Atlas URI
4. Deploy:

```bash
heroku create safegirl-pro-api
git push heroku main
heroku config:set JWT_SECRET=your_production_secret
```

### Deploy to AWS/DigitalOcean

1. Create a droplet/instance
2. Install Node.js and MongoDB
3. Clone repository
4. Configure .env
5. Start application with process manager (PM2)

## Security Best Practices

- Change JWT_SECRET in production
- Use HTTPS in production
- Implement rate limiting
- Validate all inputs
- Use environment variables for sensitive data
- Implement proper CORS policies
- Add request logging and monitoring

## Frontend Integration

Update your Flutter app's API base URL in the services:

```dart
const String API_BASE_URL = 'http://your-backend-url:5000/api';
```

## Support

For issues or questions, contact: safegirl-pro@example.com
