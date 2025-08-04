# School Fee Register - Frontend

A modern React.js frontend for the School Fee Register System with Material-UI components and Redux state management.

## 🚀 Features

### Core Features
- **Dashboard**: Overview of all microservices with real-time status
- **Student Management**: Add, view, edit, and delete student records
- **Fee Structure**: Manage fee categories, amounts, and schedules
- **Payment Processing**: Process payments with multiple payment methods
- **Notifications**: Send email and SMS notifications
- **Reports**: Generate financial reports and analytics

### UI/UX Features
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Material-UI**: Modern, accessible components
- **Dark/Light Theme**: Customizable theme support
- **Data Grids**: Advanced data tables with sorting and filtering
- **Real-time Updates**: Live status monitoring
- **Interactive Charts**: Visual data representation

## 🛠️ Technology Stack

- **React 18** with TypeScript
- **Material-UI 5** for components
- **Redux Toolkit** for state management
- **React Router 6** for navigation
- **Axios** for API communication
- **Recharts** for data visualization
- **Date-fns** for date manipulation

## 📦 Installation

1. **Navigate to frontend directory:**
   ```bash
   cd school-fee-register/frontend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Start development server:**
   ```bash
   npm start
   ```

4. **Open browser:**
   Navigate to `http://localhost:3000`

## 🏗️ Project Structure

```
frontend/
├── public/
│   ├── index.html
│   └── manifest.json
├── src/
│   ├── components/
│   │   ├── Dashboard.tsx      # Main dashboard with service status
│   │   ├── Students.tsx       # Student management
│   │   ├── Fees.tsx          # Fee structure management
│   │   ├── Payments.tsx      # Payment processing
│   │   ├── Notifications.tsx # Notification management
│   │   └── Reports.tsx       # Reports and analytics
│   ├── store/
│   │   ├── index.ts          # Redux store configuration
│   │   └── slices/
│   │       ├── studentsSlice.ts
│   │       ├── feesSlice.ts
│   │       ├── paymentsSlice.ts
│   │       └── notificationsSlice.ts
│   ├── App.tsx               # Main application component
│   └── index.tsx             # Application entry point
├── package.json
└── README.md
```

## 🎨 UI Components

### Dashboard
- **Service Status Cards**: Real-time status of all microservices
- **Statistics Overview**: Key metrics and KPIs
- **System Health**: CPU, memory, and database monitoring
- **Recent Activities**: Latest system activities

### Navigation
- **Sidebar Navigation**: Collapsible navigation menu
- **Breadcrumbs**: Clear navigation path
- **Responsive Design**: Mobile-friendly navigation

### Data Management
- **Data Grids**: Advanced tables with sorting, filtering, and pagination
- **Forms**: Material-UI form components with validation
- **Modals**: Dialog boxes for data entry and confirmation

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the frontend directory:

```env
REACT_APP_API_URL=http://localhost:8080
REACT_APP_GATEWAY_URL=http://localhost:8080
```

### API Configuration
The frontend is configured to communicate with the backend services through the API Gateway at port 8080.

## 🚀 Available Scripts

- `npm start` - Start development server
- `npm build` - Build for production
- `npm test` - Run tests
- `npm eject` - Eject from Create React App

## 📱 Responsive Design

The application is fully responsive and works on:
- **Desktop**: Full-featured interface
- **Tablet**: Optimized layout
- **Mobile**: Touch-friendly interface

## 🎯 Key Features

### Microservices Dashboard
- Real-time status monitoring of all backend services
- Service health indicators
- Port information and service descriptions
- Quick access to service-specific features

### Student Management
- Complete CRUD operations for student records
- Search and filter capabilities
- Bulk operations support
- Student status tracking

### Payment Processing
- Multiple payment method support
- Transaction tracking
- Receipt generation
- Payment history

### Reporting
- Financial reports generation
- Data visualization with charts
- Export capabilities
- Custom date range selection

## 🔐 Security

- JWT token-based authentication
- Role-based access control
- Secure API communication
- Input validation and sanitization

## 🧪 Testing

```bash
# Run tests
npm test

# Run tests with coverage
npm test -- --coverage
```

## 📦 Build for Production

```bash
# Create production build
npm run build

# Serve production build
npx serve -s build
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License. 