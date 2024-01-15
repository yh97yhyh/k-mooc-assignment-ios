import UIKit
import WebKit

class KmoocDetailViewController: UIViewController {
    @IBOutlet var viewModel: KmoocDetailViewModel!
    
    @IBOutlet var lectureImage: UIImageView!
    @IBOutlet var lectureNumber: UILabel!
    @IBOutlet var lectureType: UILabel!
    @IBOutlet var lectureOrg: UILabel!
    @IBOutlet var lectureTeachers: UILabel!
    @IBOutlet var lectureDue: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        
        viewModel.loadingStarted = { [weak self] in
            guard let self = self else { return }
            self.loading.isHidden = false
            self.loading.startAnimating()
        }
        viewModel.loadingEnded = { [weak self] in
            guard let self = self else { return }
            self.loading.stopAnimating()
        }
        viewModel.lectureUpdated = { [weak self] lecture in
            guard let self = self else { return }
            ImageLoader.loadImage(url: lecture.courseImage) { image in
                self.lectureImage.image = image
            }
            
            self.title = lecture.name
            self.lectureNumber.text = lecture.number
            self.lectureType.text = "\(lecture.classfyName) (\(lecture.middleClassfyName))"
            self.lectureOrg.text = lecture.orgName
            self.lectureTeachers.text = lecture.teachers
            self.lectureDue.text = DateUtil.dueString(start: lecture.start, end: lecture.end)
            self.webView.loadHTMLString(self.makeHtml(lecture.overview) ?? "", baseURL: nil)
        }
        
        viewModel.detail()
    }
    
    private func makeHtml(_ string: String?) -> String {
        return """
        <!doctype html>
        <html>
        <head>
            <meta charset="utf-8" />
            <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
        </head>
        <body>
        \(string ?? "")
        </body>
        </html>
        """
    }
}



extension KmoocDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] result, _ in
            guard let self = self else { return }
            if let height = result as? CGFloat {
                webView.heightAnchor.constraint(equalToConstant: height).isActive = true
                self.view.layoutIfNeeded()
            }
        }
    }
}
