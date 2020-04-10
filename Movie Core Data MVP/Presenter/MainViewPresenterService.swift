import Foundation

protocol MainViewPresenterService {
    func loadMovies()
    func deleteMovie(index: Int)
    func addMovie(movie: Movie)
}
