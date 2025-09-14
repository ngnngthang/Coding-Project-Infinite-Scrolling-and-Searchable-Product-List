# infinite_list_and_search

## Project Requirements
- You have been assigned a task to implement an infinite scrolling list of products in a Flutter **project**. The product data will be fetched from an API. Additionally, you need to provide a search functionality that allows users to search for products by name.

**Using this [product api](https://dummyjson.com/docs/products) to implement the infinite scrolling list for display list of products.**

- Acceptance Criteria
  1. Each time the user **scrolls to the end of the list, fetch the next 20 products**.
  2. **Display the list of products** with relevant information (e.g., name, price, image).
  3. Implement an **input for searching product name** (using */products/search?q* ). 
  4. Implement favorite feature for products.
    1. Favorite data should be stored in local DB or Google Firebase.

### Pre-installation requirements
Make sure your device is installed with Flutter 

Connect to Simulator/Device:
If you don’t setup the simulator/device, please setup that like the link below:
- Set up iOS simulator: https://docs.flutter.dev/get-started/install/macos#set-up-the-ios-simulator
- Set up iOS physical device: https://docs.flutter.dev/get-started/install/macos#deploy-to-physical-ios-devices
- Set up Android Device: https://docs.flutter.dev/get-started/install/macos#set-up-your-android-device
- Set up Android emulator: https://docs.flutter.dev/get-started/install/macos#set-up-the-android-emulator

#### Installation
Clean old build
```bash
  flutter clean
```

Get all dependencies
```bash
  flutter pub get
```

Install iOS pods
```bash
  cd iod/
  pod install
```

Generate models
```base
  dart run build_runner build -d
```

Run source code
```bash
  flutter run
```