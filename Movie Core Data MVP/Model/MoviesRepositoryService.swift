import Foundation

protocol MoviesRepositoryService {
    
    func getMovies(callBack: @escaping ([Movie]) -> Void)
    func deleteMovie(movie: Movie)
    func addMovie(movie: Movie)
}
