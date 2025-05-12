# Cinematy
This is a simple movie app built using the Movie DB Open API Supporting both Arabic and English languages based on device language. The app displays a list of movies based on user search, shows detailed information about selected movies, and allows users to view similar movies and casts. The challenge was implemented using Swift and UIKit, supporting iOS versions 14 through 18, with Auto Layout for proper screen size support.

Features
1. Movie List View
* A search bar at the top allows the user to search for movies by title.
* Displays movies grouped by year with:
    * Movie title
    * Overview
    * Image
    * Watchlist status that apears on search and popular when refresh screen.
* When the search bar is empty, the app shows the most popular movies by fetching data from the provided API.
* When the user enters a search term, it shows results using the search API.

2. Movie Details View
* Displays detailed information for the selected movie:
    * Title
    * Overview
    * Image
    * Tagline
    * Revenue
    * Release date
    * Status
    * Add to Watchlist button
* Shows a list of 5 similar movies.
* Displays the cast of similar movies, grouped by:
    * Actors
    * Directors
* Only the 5 most popular actors and 5 most popular directors are shown.

Architecture
MVVM-C (Model-View-ViewModel) with Coordinator Pattern with RX-Swift.

The app is built using the MVVM (Model-View-ViewModel) architecture, which allows for better separation of concerns and easier testing:
* Model: Represents the data structure, such as MovieModel, CastModel, etc.
* View: The UI layer that interacts with the user (e.g., MovieListViewController, MovieDetailsViewController).
* ViewModel: Handles the business logic, prepares the data for the view, and communicates with the use case layer.
* RxSwift is a powerful tool for building reactive, composable, and asynchronous applications in iOS. It simplifies handling complex data flows, UI updates, and error management while reducing boilerplate code. However, it’s best suited for large-scale applications with complex UI and business logic where traditional methods become cumbersome. If used correctly, RxSwift can drastically improve code maintainability, readability, and testability.

Coordinator Pattern
The Coordinator pattern is used to manage the navigation flow of the app. The coordinator is responsible for:
* Navigating between different screens (e.g., from the movie list to the movie details screen).
* Managing child view controllers and ensuring proper transitions between them.

Use Cases & Repository
* Use Cases handle specific business logic and interact with the repository to fetch data.
* Repository: Acts as the intermediary between the Use Cases and the Remote Data Source. It fetches the data and ensures it's available to the ViewModel.

Remote Data Source & Networking Layer
* RemoteDataSource handles the actual network calls to the provided APIs using a custom API Networking Layer.
* The API networking layer is responsible for constructing the requests, handling the responses, and providing the results to the repository.

Provided APIs
* A: Get Popular Movies (https://developers.themoviedb.org/3/movies/get-popular-movies)
* B: Search Movies (https://developers.themoviedb.org/3/search/search-movies)
* C: Get Movie Details (https://developers.themoviedb.org/3/movies/get-movie-details)
* D: Get Similar Movies (https://developers.themoviedb.org/3/movies/get-similar-movies)
* E: Get Movie Credits (https://developers.themoviedb.org/3/movies/get-movie-credits)
 
API Key
To use the provided APIs, an API key from The Movie DB is required.

Requirements
* Swift 5.0+
* iOS 14-18
* UIKit
* Auto Layout for proper screen size support
* CocoaPods

Code Structure
Main Components
* MovieListViewController: Handles the list of movies, search functionality, and movie details navigation.
* MovieDetailsViewController: Displays detailed movie information, similar movies, and cast lists.
* MovieService: Responsible for fetching data from the Movie DB APIs.
* MovieModel: Defines the structure of the movie data used throughout the app.
* Watchlist Manager: Manages the watchlist state.
* Localization Manager: handle both arabic and English languages.
 
Design & Layout
* UIKit and Auto Layout are used to ensure proper UI components fit across various screen sizes.
* View components are chosen for simplicity and performance. The design focus is functional and clear.
Notes
* The app does not focus on design aesthetics but prioritizes clean, functional layout and API integration.
* Watchlist functionality allows users to toggle movies in and out of their watchlist.
