import Foundation
import CoreData

class LocalMoviesRepository: LocalMoviesService {
    
    let managedContext: NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    
    // Table ChachedMovies
    func getCachedMovies() -> [Movie] {
        let moviesManagedObjects = getCachedMoviesManagedObjects()
        var movies = [Movie]()
        
        for movieManagedObject in moviesManagedObjects {
            let imageURL = movieManagedObject.value(forKey: "imageURL") as! String
            let title = movieManagedObject.value(forKey: "title") as! String
            let rating = movieManagedObject.value(forKey: "rating") as! Double
            let releaseYear = movieManagedObject.value(forKey: "releaseYear") as! Int
            let genre = movieManagedObject.value(forKey: "genre") as! String
            
            let movie = Movie(imageURL: imageURL, title: title, rating: rating, releaseYear: releaseYear, genre: genre)
            movies.append(movie)
        }
        
        return movies
    }
    
    private func getCachedMoviesManagedObjects() -> [NSManagedObject] {
        var moviesObjects = [NSManagedObject]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedMovies")
        do {
            moviesObjects += try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
        
        return moviesObjects
    }
    
    func cachMovies(movies: [Movie]) {
        DispatchQueue.main.async {
            let entity = NSEntityDescription.entity(forEntityName: "CachedMovies", in: self.managedContext)
            for movie in movies {
                let managedObject = NSManagedObject(entity: entity!, insertInto: self.managedContext)
                managedObject.setValue(movie.imageURL, forKey: "imageURL")
                managedObject.setValue(movie.title, forKey: "title")
                managedObject.setValue(movie.rating, forKey: "rating")
                managedObject.setValue(movie.releaseYear, forKey: "releaseYear")
                managedObject.setValue(movie.genre, forKey: "genre")
            }
            
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func deleteCashedMovies() {
        let moviesManagedObjects = getCachedMoviesManagedObjects()
        
        for movieManagedObject in moviesManagedObjects {
            managedContext.delete(movieManagedObject)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    // Table AddedMovies
    
    func getAddedMovies() -> [Movie] {
        var movies = [Movie]()
        
        let addedMoviesManagedObjects = getAddedMoviesManagedObjects()
        for managedObject in addedMoviesManagedObjects {
            let imageURL = managedObject.value(forKey: "imageURL") as! String
            let title = managedObject.value(forKey: "title") as! String
            let rating = managedObject.value(forKey: "rating") as! Double
            let releaseYear = managedObject.value(forKey: "releaseYear") as! Int
            let genre = managedObject.value(forKey: "genre") as! String
            
            let movie = Movie(imageURL: imageURL, title: title, rating: rating, releaseYear: releaseYear, genre: genre)
            movies.append(movie)
        }
        
        return movies
    }
    
    private func getAddedMoviesManagedObjects() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AddedMovies")
        var addedMoviesManagedObjects = [NSManagedObject]()
        
        do {
            addedMoviesManagedObjects += try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
        
        return addedMoviesManagedObjects
    }
    
    func saveMovie(movie: Movie) {
        let entity = NSEntityDescription.entity(forEntityName: "AddedMovies", in: managedContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
        managedObject.setValue(movie.imageURL, forKey: "imageURL")
        managedObject.setValue(movie.title, forKey: "title")
        managedObject.setValue(movie.rating, forKey: "rating")
        managedObject.setValue(movie.releaseYear, forKey: "releaseYear")
        managedObject.setValue(movie.genre, forKey: "genre")
        
        managedContext.insert(managedObject)
        
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    }
    
    func deleteAddedMovie(movie: Movie) {
        let entity = NSEntityDescription.entity(forEntityName: "AddedMovies", in: managedContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
        managedObject.setValue(movie.imageURL, forKey: "imageURL")
        managedObject.setValue(movie.title, forKey: "title")
        managedObject.setValue(movie.rating, forKey: "rating")
        managedObject.setValue(movie.releaseYear, forKey: "releaseYear")
        managedObject.setValue(movie.genre, forKey: "genre")
        
        managedContext.delete(managedObject)
        
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    }
    
}
