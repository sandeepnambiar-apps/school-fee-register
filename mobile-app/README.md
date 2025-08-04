# Kidsy School Management Mobile App

A React Native mobile application for school fee management with multi-language support.

## 🚀 Features

- **📱 Native Mobile Experience**: Built with React Native for true native performance
- **🌐 Multi-language Support**: English, Hindi, Telugu, Tamil
- **📊 Interactive Dashboards**: Charts and analytics
- **👥 Student Management**: Add, edit, and manage student records
- **💰 Fee Management**: Track fees, payments, and dues
- **📈 Reports**: Generate detailed reports
- **🔐 Secure Authentication**: Biometric and PIN-based login
- **📱 Offline Support**: Works without internet connection
- **🔔 Push Notifications**: Payment reminders and updates
- **📷 QR Code Scanner**: Quick student identification
- **📄 PDF Generation**: Generate receipts and reports

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v16 or higher)
- **npm** or **yarn**
- **React Native CLI**
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)
- **Java Development Kit (JDK)** 11 or higher

## 🛠️ Installation

### 1. Install React Native CLI
```bash
npm install -g @react-native-community/cli
```

### 2. Install Dependencies
```bash
cd mobile-app
npm install
```

### 3. iOS Setup (macOS only)
```bash
cd ios
pod install
cd ..
```

### 4. Android Setup
- Open Android Studio
- Open the `android` folder from the project
- Sync Gradle files
- Set up Android SDK and emulator

## 🚀 Running the App

### For Android
```bash
npm run android
```

### For iOS (macOS only)
```bash
npm run ios
```

### Start Metro Bundler
```bash
npm start
```

## 📱 Building for Production

### Android APK
```bash
npm run build:android
```

### iOS Archive
```bash
npm run build:ios
```

## 🏗️ Project Structure

```
mobile-app/
├── src/
│   ├── components/          # Reusable components
│   ├── screens/            # Screen components
│   ├── contexts/           # React contexts
│   ├── services/           # API services
│   ├── utils/              # Utility functions
│   ├── assets/             # Images, fonts, etc.
│   └── i18n/               # Internationalization
├── android/                # Android native code
├── ios/                    # iOS native code
└── package.json
```

## 🌐 API Configuration

Update the API base URL in `src/services/api.ts`:

```typescript
const API_BASE_URL = 'http://your-backend-url:8081';
```

## 🔧 Environment Setup

Create `.env` file in the root directory:

```env
API_BASE_URL=http://localhost:8081
ENVIRONMENT=development
```

## 📱 Mobile App Features

### Authentication
- Biometric login (fingerprint/face ID)
- PIN-based authentication
- Secure token storage

### Dashboard
- Real-time statistics
- Interactive charts
- Quick actions

### Student Management
- Add new students
- Edit student information
- View student details
- Search and filter

### Fee Management
- Track fee payments
- Generate receipts
- Payment reminders
- Due date notifications

### Reports
- Payment reports
- Student reports
- Financial summaries
- Export to PDF

### Offline Capabilities
- Cache student data
- Offline payment recording
- Sync when online

## 🔔 Push Notifications

The app supports push notifications for:
- Payment reminders
- Due date alerts
- System updates
- Important announcements

## 📷 QR Code Features

- Scan student QR codes
- Quick student identification
- Attendance tracking
- Payment verification

## 🎨 Customization

### Theme Colors
Update colors in `src/theme/colors.ts`:

```typescript
export const colors = {
  primary: '#1976d2',
  secondary: '#03dac4',
  background: '#f5f5f5',
  surface: '#ffffff',
  error: '#b00020',
};
```

### Language Support
Add new languages in `src/i18n/locales/`:

```json
{
  "dashboard": {
    "title": "Dashboard",
    "welcome": "Welcome to Kidsy School"
  }
}
```

## 🧪 Testing

```bash
npm test
```

## 📦 Deployment

### Google Play Store
1. Generate signed APK
2. Create developer account
3. Upload APK
4. Configure store listing

### Apple App Store
1. Archive the project
2. Upload to App Store Connect
3. Configure app metadata
4. Submit for review

## 🔒 Security Features

- Encrypted storage for sensitive data
- Biometric authentication
- Secure API communication
- Token-based authentication
- Certificate pinning

## 📞 Support

For support and questions:
- Email: support@kidsyschool.com
- Documentation: https://docs.kidsyschool.com
- GitHub Issues: https://github.com/kidsyschool/mobile-app/issues

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/kidsyschool/mobile-app.git

# Install dependencies
cd mobile-app
npm install

# Run on Android
npm run android

# Run on iOS (macOS only)
npm run ios
```

## 📱 App Screenshots

- Dashboard with charts and statistics
- Student list with search functionality
- Fee management interface
- Payment tracking
- Reports and analytics
- Settings and preferences

## 🔄 Updates

The app automatically checks for updates and can be configured to:
- Auto-update in the background
- Notify users of new features
- Force update for critical fixes

## 📊 Analytics

The app includes analytics for:
- User engagement
- Feature usage
- Performance metrics
- Error tracking
- User feedback

---

**Built with ❤️ for better school management** 