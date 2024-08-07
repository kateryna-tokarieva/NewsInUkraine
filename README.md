## Overview

**NewsInUkraine** is an iOS application that delivers the latest news articles about Ukraine. Users can view news feeds, read detailed articles, and save articles for later reading. The app fetches news from a remote API and stores saved articles locally using Core Data.

## Features

- **News Feed:** Browse the latest news articles.
- **Search Functionality:** Search for specific news articles using keywords.
- **Article Details:** View detailed information about each news article.
- **Save Articles:** Save your favorite articles for offline reading.
- **Core Data Integration:** Save and retrieve articles using Core Data.
- **SwiftUI Interface:** Built with a modern SwiftUI interface.

## Installation

### Prerequisites

- **Xcode 15 or later**: Ensure you have the latest version of Xcode installed on your Mac.
- **iOS 17.2 or later**: This app is designed to run on iOS 14.0 or later.

### Setup

1. **Clone the Repository**

   git clone https://github.com/your-username/NewsInUkraine.git
   cd NewsInUkraine
   
2. **Open the Project**
   
   Open NewsInUkraine.xcodeproj in Xcode.

3. **Build and Run**
   
    Select a simulator or connected device, then click the run button in Xcode.

## Configuration

**API Key**
The app requires an API key to fetch news articles. Update the API.swift file with your API key:

struct API {
    static let key = "YOUR_API_KEY_HERE"
}

## Usage

- **Viewing Articles:** Launch the app to view the latest news articles on the home screen.
- **Searching:** Use the search bar to filter articles based on keywords.
- **Saving Articles:** Tap the bookmark icon to save articles for offline viewing.
- **Reading Articles:** Tap on an article to read more details.

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern to separate concerns and improve testability.

- **Models:** Data structures representing news articles and API responses.
- **Views:** SwiftUI views for displaying UI components.
- **ViewModels:** Handles business logic and data manipulation for views.
