//
//  ViewController.swift
//  BoxOffice
//
//  Created by Tony Jung on 2020/09/21.
//  Copyright © 2020 com.doyeon. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //    let vc = segue.destination as? MovieDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let movieInfo = movies[indexPath.row]
        
                MovieDetailInfo.shared.movieId = movieInfo.id
            }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
     
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        let movie = movies[indexPath.item]
        let url = URL(string: movie.thumb)!
        
        cell.movieImage.kf.setImage(with: url)
        cell.title.text = movies[indexPath.row].title
        cell.date.text = "개봉일: \(movies[indexPath.row].date)"
        cell.detail.text = "평점: \(movies[indexPath.row].userRating) 예매순위: \(movies[indexPath.row].reservationGrade) 예매율: \(movies[indexPath.row].reservationRate)"
       
        switch movies[indexPath.row].grade {
        case 12:
            cell.grade.image = UIImage(named: "ic_12")
        case 15:  cell.grade.image = UIImage(named: "ic_15")
        case 19:  cell.grade.image = UIImage(named: "ic_19")
        default:
             cell.grade.image = UIImage(named: "ic_allages")
        }
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print("--->\(indexPath.row)")
       // performSegue( withIdentifier: "??", sender: indexPath.row)
    }
    
    @IBAction func sortOptionButton(_ sender: Any) {
        showAlertController()
    }
    
    func showAlertController(){
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: .actionSheet)
        
        let sortByRate = UIAlertAction(title: "예매율", style: UIAlertAction.Style.default, handler: {action in
            MovieType.shared.updateType(0)
            self.fetchMovies()
        })
              
        let sortByQue = UIAlertAction(title: "큐레이션", style: UIAlertAction.Style.default, handler: {action in
            MovieType.shared.updateType(1)
            self.fetchMovies()
      
        })
        let sortByDate = UIAlertAction(title: "개봉일", style: UIAlertAction.Style.default, handler: {action in
            MovieType.shared.updateType(2)
            self.fetchMovies()
   
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil) //.cancel
                
              alertController.addAction(sortByRate)
              alertController.addAction(sortByQue)
              alertController.addAction(sortByDate)
              alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: {
        })
    }
    
    func fetchMovies(){
        ParseAPI.loadMovies(MovieType.shared.fetchType()) { movies in
        DispatchQueue.main.async {
                self.movies = movies
        
            switch MovieType.shared.fetchType(){ //밖으로빼서 해주면 좋을듯
            case 0: self.navigationItem.title = "예매율순"
            case 1: self.navigationItem.title = "큐레이션순"
            case 2: self.navigationItem.title = "개봉일순"
                
            default:
                self.navigationItem.title = "예매율순"
            }
                self.tableView.reloadData()
            
        }
        }
    }
    
    
}

class TableCell: UITableViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var availableAge: UILabel!
    //circle & label color need to be change

   
    @IBOutlet weak var circle: UIImageView!
    
    @IBOutlet weak var grade: UIImageView!
}

struct Response: Codable {
    let movies: [Movie]
}

struct Movie: Codable {
    let date: String
    let title: String
    let userRating: Double
    let reservationRate: Double
    let thumb: String
    let reservationGrade: Int
    let id: String
    let grade: Int
    
    enum CodingKeys: String, CodingKey{
        case date
        case title
        case userRating = "user_rating"
        case reservationRate = "reservation_rate"
        case thumb
        case reservationGrade = "reservation_grade"
        case id
        case grade
    }
}



class MovieType {
    static let shared: MovieType = MovieType()
    var type: Int = 0
    
    func updateType(_ type : Int) {
        self.type = type
    }
    func fetchType() -> Int {
        return type
    }
}
