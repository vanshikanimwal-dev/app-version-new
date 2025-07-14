# Ferrero Asset Management App (Prototype)

## Project Overview

This project is a Flutter-based mobile application prototype designed for managing and verifying assets for Ferrero outlets. It streamlines the process of capturing essential shop data, including photos, location details, and facilitating a digital consent and OTP verification workflow with shop owners.

The application is built with a focus on demonstrating core functionalities for field agents to efficiently collect and submit asset information.

## Features

* **Shop Search & Filtering:** Agents can search for specific retail outlets and filter them by various statuses (e.g., Completed, In Progress, Pending, Open, Not Completed, Reject).
* **Status-Based Interaction:**
    * **"Pending" Shops:** Allow agents to capture new asset photos, record location, and initiate a digital agreement process.
    * **"Completed" Shops:** Display existing, read-only shop and asset details, with an option to view the signed consent form.
* **Comprehensive Asset Capture:**
    * Capture multiple types of photos: Outlet Exteriors, Asset Photos, Outlet Owner ID, Outlet Owner Photo, and Serial Number Photo.
    * Automatic GPS location tagging for captured assets.
* **Digital Consent & OTP Verification:**
    * A dedicated flow to present a digital consent form (displayed as an image).
    * Secure verification of consent through a 6-digit One-Time Password (OTP) sent to the outlet owner's mobile number via SMS.
* **Centralized Data Management:** Utilizes the `Provider` package for efficient state management, ensuring collected data is accessible across different parts of the application.
* **Simulated API Integration:** The application's structure is prepared for integration with a backend API for data submission and retrieval, currently simulated for prototype purposes.

## Technologies Used

* **Flutter (Dart):** The UI framework for building cross-platform mobile applications.
* **Provider:** For robust and scalable state management.
* **`image_picker`:** To access the device camera for photo capture.
* **`geolocator`:** For obtaining precise GPS location data.
* **`http`:** For making network requests (e.g., simulated API calls, SMS sending).
* **`flutter_pdfview` (Internal Logic):** While the direct PDF viewing from URL was replaced by an image for the prototype, the `flutter_pdfview` package was explored for local PDF display.
* **`logging`:** For structured application logging and debugging.
* **`shared_preferences`:** For local data persistence (e.g., user preferences, authentication tokens).
* **`intl`:** For internationalization and localization support.

## Setup and Installation

To get a local copy of the project up and running, follow these steps:

### Prerequisites

* **Flutter SDK:** Ensure you have Flutter installed. Follow the official Flutter installation guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
* **Dart SDK:** Included with Flutter.
* **IDE:** Visual Studio Code with Flutter extension or Android Studio.

### Cloning the Repository

```bash
git clone <your-repository-url>
cd ferrero_asset_management
Get Dependencies
Navigate to the project root and run:

Bash

flutter pub get
Asset Setup
Ensure your static assets are correctly placed and declared:

Image Assets:

Place all general images (e.g., homescreen.png, logo.png, rect1.png, choco.png, pfp.png) directly in the assets/ folder.

Place sample images for asset capture (e.g., sample_outlet_exterior.jpg, sample_asset_pic.jpg, sample_owner_id.jpg, sample_owner_pic.jpg, sample_serial_no.jpg) in the assets/images/ folder.

Place the consent form image (e.g., consent_form_image.png) in assets/images/.

pubspec.yaml Declaration:
Verify your pubspec.yaml flutter: section includes these assets with correct indentation:

YAML

flutter:
  uses-material-design: true
  assets:
    - assets/homescreen.png
    - assets/pfp.png
    - assets/rect1.png
    - assets/choco.png
    - assets/logo.png
    - assets/images/sample_outlet_exterior.jpg
    - assets/images/sample_asset_pic.jpg
    - assets/images/sample_owner_id.jpg
    - assets/images/sample_owner_pic.jpg
    - assets/images/sample_serial_no.jpg
    - assets/images/consent_form_image.png # Ensure this is present
After any changes to pubspec.yaml, always run flutter pub get.

Platform-Specific Setup (Important)
Android
Open android/app/src/main/AndroidManifest.xml and ensure the following permissions and queries are present within the <manifest> tag:

XML

<manifest xmlns:android="[http://schemas.android.com/apk/res/android](http://schemas.android.com/apk/res/android)">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-feature android:name="android.hardware.camera" android:required="true"/>
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />
    <uses-permission android:name="android.permission.SEND_SMS"/>

    <application
        android:label="ferrero asset management"
        android:name="${applicationName}"
        android:icon="@mipmap/play_store_512"
        android:requestLegacyExternalStorage="true" >
        <!-- ... your activity and meta-data ... -->
    </application>

    <!-- Required for Android 11 (API 30) and above for package visibility -->
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
        <!-- For opening web links (if url_launcher was used, now replaced by in-app image) -->
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="https" />
        </intent>
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="http" />
        </intent>
        <!-- For sending SMS -->
        <intent>
            <action android:name="android.intent.action.SENDTO" />
            <data android:scheme="smsto" />
        </intent>
    </queries>
</manifest>
iOS
Open ios/Runner/Info.plist and add the following keys:

XML

<plist version="1.0">
<dict>
    <!-- ... other keys ... -->
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to capture asset photos.</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs photo library access to select asset photos.</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs location access to tag captured assets with GPS coordinates.</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>This app needs always-on location access to tag captured assets with GPS coordinates for background operations.</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>This app needs always-on location access for background operations.</string>
</dict>
</plist>
Running the Application
After all steps, run the application:

Bash

flutter run
Usage
Login: Start by logging into the application (assuming a simple login for prototype).

Shop Search: On the main screen, use the search bar to find shops by name.

Filter by Status: Use the hamburger menu icon (top-left) to open the drawer and filter shops by their status (e.g., "Completed", "Pending").

Interacting with Shops:

"Pending" Shops: Tapping on a pending shop will take you to the Asset Capture page where you can fill in details, capture photos, and get location. After capturing all required assets, click "initiate agreement" to proceed to the Consent and OTP Verification page.

"Completed" Shops: Tapping on a completed shop will display its details in a read-only mode. The "Continue" button will open the consent form (as an image) in a new screen.

Consent & OTP Verification: For pending shops, after asset capture, you'll be guided through providing consent and verifying it with an OTP sent to the owner's mobile number.

Project Structure
ferrero_asset_management/
├── android/                 # Android specific files
├── ios/                     # iOS specific files
├── assets/                  # Static assets (images, consent form image)
│   ├── images/              # Sample images for asset capture and consent form image
│   └── ...other_images.png
├── lib/                     # Dart source code
│   ├── models/              # Data models (e.g., Shop, StudentSitting)
│   ├── provider/            # DataProvider for state management
│   ├── screens/             # UI pages
│   │   ├── auth/            # Authentication related screens
│   │   ├── shops/           # Shop listing and details (ConsentFormPage)
│   │   ├── assets/          # Asset capture screen (AssetCapturePage)
│   │   ├── consent/         # Consent and OTP verification screen
│   │   ├── completion/      # Completion screen
│   │   └── image_viewer/    # Generic image viewer screen
│   ├── services/            # API interaction, SMS sending logic (AppApiService)
│   └── widgets/             # Reusable UI components (styled_button, otp_input_field, photo_capture_grid_item)
├── pubspec.yaml             # Project dependencies and metadata
└── README.md                # This file
Future Enhancements
Full Backend Integration: Implement actual API calls for persistent data storage and retrieval.

User Authentication: Implement a robust user authentication system (e.g., Firebase Auth, custom API).

Error Handling & UI Feedback: Enhance error messages and provide more intuitive user feedback for network issues, API failures, etc.

Offline Capabilities: Implement local caching for data and images to support offline usage.

Dynamic Status Management: Allow dynamic updates to shop statuses based on workflow progression.

Image Upload to Cloud Storage: Integrate with cloud storage solutions (e.g., Firebase Storage, AWS S3) for efficient image handling.

Improved Consent Form Display: Explore more interactive or native PDF rendering solutions if needed for multi-page PDFs with annotations.

Contributing
Contributions are welcome! Please feel free to open issues or submit pull requests.

License
This project is licensed under the MIT License - see the LICENSE file for details.
