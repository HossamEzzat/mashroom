<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  
  <br />
  <br />

  <h1>🍄 Mashroom</h1>
  <p>
    <strong>An intelligent, AI-powered agricultural mobile application.</strong>
  </p>

  <p>
    <a href="#features">Features</a> •
    <a href="#tech-stack">Tech Stack</a> •
    <a href="#getting-started">Getting Started</a> •
    <a href="#architecture">Architecture</a>
  </p>
</div>

---

## 🌟 About The Project

**Mashroom** is a smart agricultural mobile app built with Flutter. It integrates advanced machine learning and multi-objective optimization algorithms to help modern farmers predict crop diseases and intelligently plan their fields for maximum sustainability, yield, and profit.

---

## ✨ Features

- 🌿 **Geo Crop Planner**: An AI-powered feature utilizing the `NSGA-II` evolutionary algorithm to recommend the best possible crop distribution based on:
  - Land Area (Hectares)
  - Soil Data (Nitrogen, Phosphorus, Potassium, pH)
  - Climate Data (Temperature, Humidity, Rainfall)
  - User Constraints (Water limit, Budget limit)
  - Custom Optimization Goals (*Sustainability First, Profit First, Balanced, Water Saving, Low Carbon*)
- 🍄 **Mushroom Disease Prediction**: Take or upload pictures of mushrooms/crops to detect potential diseases using Roboflow and custom machine learning models.
- 🥘 **Sustainable Recipes**: Browse healthy and sustainable agricultural recipes with beautiful UI cards.
- 📍 **Automatic Geo-location**: Fetches real-time weather and climate data for your farm's exact location.

---

## 🛠 Tech Stack

### Frontend (Mobile App)
- **Framework:** Flutter & Dart
- **State Management:** Provider
- **Location & Weather:** `geolocator`, Open-Meteo API
- **Networking:** HTTP

### Backend (Python Service)
- **Framework:** Flask (Python 3.11)
- **Algorithms:** Multi-objective Evolutionary Algorithm (`NSGA-II`)
- **Data processing:** Pandas, NumPy
- **Machine Learning:** Scikit-Learn, Joblib

---

## 🚀 Getting Started

Follow these instructions to set up the project locally for development and testing.

### Prerequisites
1. **Flutter SDK** (v3.0+) installed.
2. **Android Studio** / **VS Code** with Flutter extensions.
3. **Python 3.10+** (For running the backend API).

### 1. Run the Backend API
The Flutter app requires the local Python backend to calculate AI optimization metrics.
```bash
# Navigate to the backend directory
cd path/to/mushroomies

# Activate the virtual environment
.\venv_new\Scripts\activate

# Start the Flask API
python main.py
```
> **Note:** The backend will run on `http://0.0.0.0:5000`. 

### 2. Run the Flutter App
Ensure the backend is running, then start the Flutter application.
```bash
# Navigate to the Flutter project directory
cd path/to/mashroom

# Get dependencies
flutter pub get

# Run the app
flutter run
```

---

## 📡 API Endpoints

The mobile app connects to the following key AI endpoints:
- `POST /crop/optimize`: Runs the NSGA-II algorithm to find optimal land allocation.
- `POST /crop/recommend`: Provides quick AI-driven recommendations without heavy generation.
- `POST /predict_local`: Predicts diseases via the custom trained model.

*(Check `lib/core/constants/api_endpoints.dart` to modify the base URL depending on your network).*

---

## 🎨 UI Showcase
The UI embraces modern, glassmorphic design principles with a highly interactive experience tailored to make complex AI data digestible and beautiful.

<div align="center">
  <i>Built with ❤️ using Flutter and Python.</i>
</div>
