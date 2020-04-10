import UIKit

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var movieIV: UIImageView!
    @IBOutlet weak var titleTV: UITextField!
    @IBOutlet weak var ratingTV: UITextField!
    @IBOutlet weak var releaseYearTV: UITextField!
    @IBOutlet weak var genreTV: UITextField!
    var addDelegate: AddMovieDelegate?
    var imageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(self.done(sender:)))
        navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    @objc func done(sender: UIBarButtonItem) {
        if let ad = addDelegate {
            
            let movieTitle = titleTV.text!
            let rating = Double(ratingTV.text!)
            let releaseYear = Int(releaseYearTV.text!)
            let gener = genreTV.text!
            
            let movie = Movie(imageURL: imageURL!, title: movieTitle, rating: rating, releaseYear: releaseYear, genre: gener)
            
            ad.movieFilled(movie: movie)
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func pickImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            movieIV.image = image
        }
        
        if let url = info[.imageURL] as? URL {
            imageURL = url.path
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
