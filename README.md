Here’s an updated `README.md` for your GitHub repository:


# Location Tracker

A Flutter application that tracks the user's location in real time and checks if they are within a defined geographical range. If the user enters or exits the defined range, a notification is shown.

## Features

- Tracks the user's real-time location using `geolocator` package.
- Displays the user's location on a Google Map using `google_maps_flutter`.
- Defines a circular geographical range and checks if the user is within it.
- Sends notifications when the user enters or exits the defined range.
- Supports continuous location updates via streaming.
- Simple, user-friendly interface with location tracking features.

## Project Setup

### Prerequisites

Before you start, ensure you have the following installed on your system:

- Flutter SDK
- Android Studio or Visual Studio Code (with Flutter and Dart plugins installed)
- Google Maps API Key (for the map integration)

### Clone the Repository

To clone this repository to your local machine, run:
```
git clone https://github.com/Shehzaan-Mansuri/Location_tracker.git
```

### API Key Setup

You will need to set up your **Google Maps API Key**. 

1. Open `android/app/src/main/AndroidManifest.xml`.
2. Add your Google Maps API Key in the following line:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

Make sure to replace `YOUR_API_KEY_HERE` with your actual API key.

### Dependencies

This project uses the following dependencies:

- `google_maps_flutter`: For integrating Google Maps.
- `geolocator`: To access the device's location and track movements.
- `flutter_local_notifications`: For displaying notifications when the user enters/exits the defined range.

Install the required dependencies by running:

```bash
flutter pub get
```

### Android Permissions

Ensure the following permissions are added to your `android/app/src/main/AndroidManifest.xml` for location access:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### Running the App

After setting up the project, run the app using:

```bash
flutter run
```

## How It Works

1. The app requests location permissions from the user.
2. Once permission is granted, the app fetches the current location and sets a radius of 500 meters around the initial position.
3. A map is displayed with the user’s position marked, and a circular area (range) is drawn on the map.
4. As the user moves, the app continuously tracks their position.
5. When the user enters or exits the predefined range, a notification is shown.

## Contributing

Feel free to fork the repository and submit pull requests for any improvements or bug fixes. 

### Steps to contribute:

1. Fork the repo.
2. Create a new branch for your feature or fix.
3. Commit your changes.
4. Push your changes to your fork.
5. Open a pull request to the `main` branch.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

### Changes in the `README.md`:
- Updated the repository URL to `https://github.com/Shehzaan-Mansuri/Location_tracker.git`.
- Included instructions for API key setup and permissions for Google Maps and location services.
- Added steps for cloning, installing dependencies, and running the app.
- Added a basic contributing guide for those who want to contribute to the project.

This should provide a comprehensive guide for anyone who clones your repository. You can now push this `README.md` to your GitHub repository on the `main` branch!