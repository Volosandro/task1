//
//  ViewController.swift
//  task1
//
//  Created by Volosandro on 30.10.2022.
//

import UIKit

class Button: UIButton
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEnabled()
    {
        self.backgroundColor = .systemBlue
        self.isEnabled = true
    }
    
    func setDisabled()
    {
        self.backgroundColor = .systemGray
        self.isEnabled = false
    }
}

class ViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    var textField: UITextField!
    var loginTextField: UITextField!
    var passwordTextField: UITextField!
    var button: Button!
    var openButton: Button!
    var deleteButton: Button!
    var progressView: UIProgressView!
    var pauseResumeButton: Button!
    var cancelButton: Button!
    
    // MARK: - Constants
    let downloadManager = DownloadManager()
    let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask)[0]
    
    // MARK: - Variables
    var localFileURL: URL? = nil
    lazy var downloadsSession: URLSession = {
        let config = URLSessionConfiguration.default
        let userPasswordString = "\(self.loginTextField.text ?? ""):\(self.passwordTextField.text ?? "")"
        let userPasswordData = userPasswordString.data(using: .utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        let authString = "Basic \(base64EncodedCredential)"

        return URLSession(configuration: config,
                          delegate: self,
                          delegateQueue: nil)
    }()
    
    // MARK: - Configure views
    private func addTextEdit()
    {
        self.textField = UITextField(frame: .zero)
        self.textField.placeholder = "Введите ссылку на файл для загрузки"
        self.textField.borderStyle = .roundedRect
        self.textField.layer.borderColor = UIColor.systemGray.cgColor
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.textField)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.textField!,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.textField!,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: -20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.textField!,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 50))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.textField!,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .top,
                                                   multiplier: 1,
                                                   constant: 0))
    }
    
    private func addHttpAuthTextEdit()
    {
        self.loginTextField = UITextField(frame: .zero)
        self.loginTextField.placeholder = "Логин"
        self.loginTextField.borderStyle = .roundedRect
        self.loginTextField.layer.borderColor = UIColor.systemGray.cgColor
        self.loginTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.loginTextField)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.loginTextField!,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.loginTextField!,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: -20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.loginTextField!,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 50))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.loginTextField!,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self.cancelButton.safeAreaLayoutGuide,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 50))
        
        self.passwordTextField = UITextField(frame: .zero)
        self.passwordTextField.placeholder = "Пароль"
        self.passwordTextField.borderStyle = .roundedRect
        self.passwordTextField.layer.borderColor = UIColor.systemGray.cgColor
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.passwordTextField)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.passwordTextField!,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.passwordTextField!,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: -20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.passwordTextField!,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 50))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.passwordTextField!,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self.loginTextField.safeAreaLayoutGuide,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 20))
    }
    
    private func addProgressView()
    {
        self.progressView = UIProgressView(frame: .zero)
        self.progressView.progress = 0
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        self.progressView.isHidden = true
        
        self.view.addSubview(self.progressView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.progressView!,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.progressView!,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: -20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.progressView!,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 10))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.progressView!,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self.textField.safeAreaLayoutGuide,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 10))
    }
    
    private func addButtons()
    {
        self.addOkButton()
        self.addOpenButton()
        self.addDeleteButton()
        self.addPauseResumeButton()
        self.addCancelButton()
    }
    
    private func addOkButton()
    {
        self.button = Button(frame: .zero)
        self.button.setTitle("Скачать", for: .normal)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.setEnabled()
        self.button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        
        self.view.addSubview(self.button)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.button!,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 50))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.button!,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.button!,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: -20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.button!,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self.progressView.safeAreaLayoutGuide,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 10))
    }
    
    private func addOpenButton()
    {
        self.openButton = Button(frame: .zero)
        self.openButton.setDisabled()
        self.openButton.setTitle("Открыть", for: .normal)
        self.openButton.translatesAutoresizingMaskIntoConstraints = false
        self.openButton.addTarget(self, action: #selector(onOpenButtonTap), for: .touchUpInside)
        
        self.view.addSubview(self.openButton)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.openButton!,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 50))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.openButton!,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.openButton!,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: -20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.openButton!,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self.button.safeAreaLayoutGuide,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 10))
    }
    
    private func addDeleteButton()
    {
        self.deleteButton = Button(frame: .zero)
        self.deleteButton.setDisabled()
        self.deleteButton.setTitle("Удалить", for: .normal)
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.deleteButton.addTarget(self, action: #selector(onDeleteButtonTap), for: .touchUpInside)
        
        self.view.addSubview(self.deleteButton)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.deleteButton!,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 50))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.deleteButton!,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.deleteButton!,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: -20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.deleteButton!,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self.openButton.safeAreaLayoutGuide,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 10))
    }
    
    private func addPauseResumeButton()
    {
        self.pauseResumeButton = Button(frame: .zero)
        self.pauseResumeButton.setDisabled()
        self.pauseResumeButton.setTitle("Пауза", for: .normal)
        self.pauseResumeButton.translatesAutoresizingMaskIntoConstraints = false
        self.pauseResumeButton.addTarget(self, action: #selector(onPauseButtonTap), for: .touchUpInside)
        
        self.view.addSubview(self.pauseResumeButton)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.pauseResumeButton!,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 50))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.pauseResumeButton!,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.pauseResumeButton!,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: -20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.pauseResumeButton!,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self.deleteButton.safeAreaLayoutGuide,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 10))
    }
    
    func addCancelButton()
    {
        self.cancelButton = Button(frame: .zero)
        self.cancelButton.setDisabled()
        self.cancelButton.setTitle("Отмена", for: .normal)
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.addTarget(self, action: #selector(onCancelButtonTap), for: .touchUpInside)
        
        self.view.addSubview(self.cancelButton)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.cancelButton!,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 50))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.cancelButton!,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.cancelButton!,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: self.view.safeAreaLayoutGuide,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: -20))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.cancelButton!,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self.pauseResumeButton.safeAreaLayoutGuide,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 10))
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addTextEdit()
        self.addProgressView()
        self.addButtons()
        self.addHttpAuthTextEdit()
    }
    
    @objc func onOpenButtonTap(_ sender: Any)
    {
        guard let localFileURL = localFileURL else {
            return
        }

        let viewer = UIDocumentInteractionController(url: localFileURL)
        viewer.delegate = self
        viewer.presentOptionsMenu(from: self.openButton.frame,
                                  in: self.view,
                                  animated: true)
    }
    
    @objc func onButtonTap(_ sender: Any)
    {
        let urlString = textField.text ?? ""
        if isValidURL(urlString)
        {
            let url = URL(string: urlString)
            self.downloadManager.downloadsSession = self.downloadsSession
            self.downloadManager.startDownload(url: url!)
            self.progressView.isHidden = false
            self.cancelButton.setEnabled()
            self.pauseResumeButton.setEnabled()
            self.button.setDisabled()
        }
        else
        {
            showErrorDialog(message: "Введите корректный URL")
        }
    }
    
    @objc func onDeleteButtonTap(_ sender: Any)
    {
        if let localFileURL = localFileURL {
            do
            {
                try FileManager.default.removeItem(at: localFileURL)
            }
            catch
            {
                showErrorDialog(message: "Не удалось удалить файл")
            }
           
            self.openButton.setDisabled()
            self.deleteButton.setDisabled()
        }
    }
    
    @objc func onPauseButtonTap(_ sender: Any)
    {
        guard let isDownloading = self.downloadManager.activeDownload?.isDownloading else { return }
            
        if isDownloading
        {
            self.downloadManager.pauseDownload()
            self.pauseResumeButton.setTitle("Возобновить", for: .normal)
        }
        else
        {
            self.downloadManager.resumeDownload()
            self.pauseResumeButton.setTitle("Пауза", for: .normal)
        }
    }
    
    @objc func onCancelButtonTap(_ sender: Any)
    {
        self.downloadManager.cancelDownload()
        self.progressView.progress = 0
        self.progressView.isHidden = true
        self.cancelButton.setDisabled()
        self.pauseResumeButton.setDisabled()
        self.pauseResumeButton.setTitle("Пауза", for: .normal)
        self.button.setEnabled()
    }
    
    private func isValidURL(_ string: String) -> Bool
    {
        let regEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
        return predicate.evaluate(with: string)
    }
    
    private func showErrorDialog(message: String)
    {
        let alertController = UIAlertController(title: "Ошибка",
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Закрыть",
                                                style: .default))
        
        self.present(alertController, animated: true)
    }
}

extension ViewController: URLSessionDownloadDelegate
{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.localFileURL = location
        DispatchQueue.main.async {
            do
            {
                let fileData = try Data(contentsOf: location)
                self.localFileURL = self.documentDirectory.appendingPathComponent(downloadTask.response?.suggestedFilename ?? "")
                try fileData.write(to: self.localFileURL ?? self.documentDirectory)
            
                self.openButton.setEnabled()
                self.deleteButton.setEnabled()
                self.progressView.isHidden = true
            }
            catch
            {
                self.showErrorDialog(message: error.localizedDescription)
            }
            
            self.pauseResumeButton.setDisabled()
            self.cancelButton.setDisabled()
            self.button.setEnabled()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.progressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
    }
}
