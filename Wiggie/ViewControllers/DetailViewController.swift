//
//  DetailViewController.swift
//  Wiggie
//
//  Created by Amit  Chakradhari on 05/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
    var imdbId: String = ""
    var imageView: UIImageView!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        
        imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
            
        ])
        // Do any additional setup after loading the view.
        NetworkWorker.getMovieDetail(imdbId: imdbId) { movieDetail, error in
            guard error == nil else {
                print("error in details",error ?? "")
                return
            }
            if let details = movieDetail, let imageUrl = URL(string: details.Poster ?? "") {
                self.imageView.sd_setImage(with: imageUrl)
                self.label.text = details.Title
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
