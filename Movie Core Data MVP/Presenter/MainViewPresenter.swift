import Foundation
import CoreData

class MainViewPresenter: MainViewPresenterService {
    
    let mainView: MainViewService
    let managedContext: NSManagedObjectContext
    let moviesRepo: MoviesRepositoryService
    var movies: [Movie]?
    
    init(mainView: MainViewService, managedContext: NSManagedObjectContext) {
        self.mainView = mainView
        self.managedContext = managedContext
        moviesRepo = MoviesRepository(managedContext: self.managedContext, urlStr: "http://api.androidhive.info/json/movies.json")
    }
    
    func loadMovies() {
        moviesRepo.getMovies(callBack: { loadedMovies in
            self.movies = loadedMovies
            self.mainView.setMovies(movies: self.movies!)
            DispatchQueue.main.async {
                self.mainView.updateTableView()
            }
        })
    }
    
    func deleteMovie(index: Int) {
        moviesRepo.deleteMovie(movie: movies![index])
        movies?.remove(at: index)
        mainView.updateTableView()
    }
    
    func addMovie(movie: Movie) {
        moviesRepo.addMovie(movie: movie)
        movies!.append(movie)
        mainView.updateTableView()
    }
    
}
