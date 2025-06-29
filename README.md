# GameBacklogApp

iOS app for managing a game backlog with offline support

## Features

- Add, edit, delete games with title, platform, cover URL, status, rating, notes, genres
- Fuzzy search using Levenshtein distance
- Sorting and filtering by title, platform, rating, status
- Offline support via Core Data with sync on reconnect
- Neo-Retro design with custom fonts and color themes
- MVVM architecture

## Screenshots

### Login
<img src="GameBacklogApp/Docs/ReadmeScreens/LoginView.PNG" width="400"/>

### Game List
<img src="GameBacklogApp/Docs/ReadmeScreens/GameListView.PNG" width="400"/>

### Fuzzy Search
<img src="GameBacklogApp/Docs/ReadmeScreens/LevenshteinDistanceSearch.PNG" width="400"/>

### Game Detail
<img src="GameBacklogApp/Docs/ReadmeScreens/GameDetailView.PNG" width="400"/>

### Edit Game
<img src="GameBacklogApp/Docs/ReadmeScreens/EditGameView1.PNG" width="400"/>
<img src="GameBacklogApp/Docs/ReadmeScreens/EditGameView2.PNG" width="400"/>

### Sorting and Filtering
<img src="GameBacklogApp/Docs/ReadmeScreens/SortingFiltering1.PNG" width="400"/>
<img src="GameBacklogApp/Docs/ReadmeScreens/SortingFiltering2.PNG" width="400"/>

### Offline Mode
<img src="GameBacklogApp/Docs/ReadmeScreens/OfflineMode.PNG" width="400"/>

### UML diagram
<img src="GameBacklogApp/Docs/ReadmeScreens/UML.PNG" width="400"/>

## Requirements

- Xcode 15+
- iOS 17+
- Swift 5.9+
- Vapor backend (local or deployed)

## Launch

1. Clone repository
2. Open in Xcode
3. Run on simulator or device
4. Ensure backend server is running and accessible