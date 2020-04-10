import Foundation
import CoreData
import SystemConfiguration

class MoviesRepository: MoviesRepositoryService {
    
    let localRepo: LocalMoviesService
    let remoteRepo: RemoteMoviesService
    
    init(managedContext: NSManagedObjectContext, urlStr: String) {
        localRepo = LocalMoviesRepository(managedContext: managedContext)
        remoteRepo = RemoteMoviesRepository(urlStr: urlStr)
    }
    
    func getMovies(callBack: @escaping ([Movie]) -> Void) {
        var movies = [Movie]()
        
        if checkReachable() {
            // if network availabel
            // get remote movies and delete old cached movies
            // and cach new remote movies
            remoteRepo.getRemoteMovies(callBack: { remoteMovies in
                movies += remoteMovies
                self.localRepo.deleteCashedMovies()
                self.localRepo.cachMovies(movies: movies)
                callBack(movies)
            })
            
            // get added movies
            movies += localRepo.getAddedMovies()
        } else {
            // if network not availabel
            // get cached movies and added movies
            movies += localRepo.getCachedMovies()
            movies += localRepo.getAddedMovies()
        }
    }
    
    func deleteMovie(movie: Movie) {
        localRepo.deleteAddedMovie(movie: movie)
    }
    
    func addMovie(movie: Movie) {
        localRepo.saveMovie(movie: movie)
    }
    
    private func checkReachable() ->Bool{
        let reachability = SCNetworkReachabilityCreateWithName(nil, "www.bing.com")
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        if isNetworkReachable(with: flags) {
            return true
        }
        
        return false
        
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
        
    }
    
}
