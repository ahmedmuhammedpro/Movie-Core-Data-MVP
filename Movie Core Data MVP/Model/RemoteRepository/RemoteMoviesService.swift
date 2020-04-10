import Foundation

protocol RemoteMoviesService {
    func getRemoteMovies(callBack: @escaping ([Movie]) -> Void)
}
