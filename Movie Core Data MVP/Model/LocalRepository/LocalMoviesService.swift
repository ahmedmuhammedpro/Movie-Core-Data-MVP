import Foundation

protocol LocalMoviesService {
    func getCachedMovies() -> [Movie]
    func cachMovies(movies: [Movie])
    func deleteCashedMovies()
    func getAddedMovies() -> [Movie]
    func saveMovie(movie: Movie)
    func deleteAddedMovie(movie: Movie)
}
