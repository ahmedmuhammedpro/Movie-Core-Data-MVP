import Foundation

class RemoteMoviesRepository: RemoteMoviesService {
    
    let urlStr: String
    init(urlStr: String) {
        self.urlStr = urlStr
    }
    
    func getRemoteMovies(callBack: @escaping ([Movie]) -> Void) {
        
        var movies = [Movie]()
        
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String: Any]]
                
                for element in json {
                    let imageURL = element["image"] as! String
                    let title = element["title"] as! String
                    let rating = element["rating"] as! Double
                    let releaseYeaer = element["releaseYear"] as! Int
                    let genre = getFormatedGenre(element["genre"] as! [String])
                    
                    let movie = Movie(imageURL: imageURL, title: title, rating: rating, releaseYear: releaseYeaer, genre: genre)
                    movies.append(movie)
                }
                
                callBack(movies)
                
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}

private func getFormatedGenre(_ genreArr: [String]) -> String {
    var genre = ""
    for value in genreArr[0..<genreArr.count - 1] {
        genre += value + ", "
    }
    
    genre += genreArr[genreArr.count - 1]
    return genre
}
