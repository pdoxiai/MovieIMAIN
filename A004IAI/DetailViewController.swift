//
//  DetailViewController.swift
//  A004IAI
//
//  Created by comsoft on 2024/06/05.
//

import UIKit
import WebKit
class DetailViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    //   @IBOutlet weak var nameLabel: UILabel!
    var movieName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        nameLabel.text = movieName
        navigationItem.title = movieName
        let urlKorString = "https://search.naver.com/search.naver?where=nexearch&sm=tab_etc&qvt=0&query=박스오피스"+movieName
        let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
