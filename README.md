# Moviezapp
Simple iOS app movie which developed in Swift (UIKit) and only using native frameworks which means no 3rd-party library implemented.
Built with MVVM Architecture by using Observable, use CoreData for insert, read, and delete local data functionality.
Using TMDB API to provide movies data for this app.
All images like movie poster and user avatar are cached after first time load (asynchronously) by using NSCache.
Implement infinite scrolling for List Movies (maximum page limit from TMDB is 500 pages).

Main Functionality:
1. Show list of popular, upcoming, top rated and now playing movies
2. Show the detail information and reviews of the movie
3. Add movie to favorite list, read all favorite movies, delete movie by swipe left on favorite movie table cell (this operations are only for local data)
