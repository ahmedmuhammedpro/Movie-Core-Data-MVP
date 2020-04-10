import UIKit
import CoreData
import Kingfisher

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MainViewService, AddMovieDelegate {
    
    @IBOutlet weak var moviesTabel: UITableView!
    var movies = [Movie]()
    var mainPresenter: MainViewPresenterService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTabel.delegate = self
        moviesTabel.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        mainPresenter = MainViewPresenter(mainView: self, managedContext: managedContext)
        mainPresenter?.loadMovies()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = movies[indexPath.row]
        let cell = moviesTabel.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.movieImageView.kf.setImage(with: URL(string: movie.imageURL!))
        cell.movieTitleLabel.text = movie.title!
        cell.movieRatingLabel.text = "\(movie.rating!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mainPresenter?.deleteMovie(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func setMovies(movies: [Movie]) {
        self.movies = movies
    }
    
    func updateTableView() {
        print(movies.count)
        moviesTabel.reloadData()
    }
    
    @IBAction func goToAddMovieView(_ sender: UIBarButtonItem) {
        let addView = storyboard?.instantiateViewController(identifier: "addView") as! AddViewController
        addView.addDelegate = self
        navigationController?.pushViewController(addView, animated: true)
    }
    
    func movieFilled(movie: Movie) {
        mainPresenter?.addMovie(movie: movie)
    }

}
