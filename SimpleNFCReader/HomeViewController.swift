//
//  ViewController.swift
//  SimpleNFCReader
//
//  Created by Leo on 26/07/21.
//

import CoreNFC
import UIKit

class HomeViewController: UIViewController {
    var nfcSession: NFCReaderSession?
    var sessionTag: NFCTagReaderSession?
    var writer: NFCNDEFTag?
    var word = "None"

    private lazy var scanButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.blue, for: .normal)
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scanTapped)))
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        return btn
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Please scan for the result"
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }

    override func loadView() {
        let v = UIView()
        v.backgroundColor = .white
        view = v
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Simple NFC Reader"
    }

    private func setupUI() {
        view.addSubview(messageLabel)
        view.addSubview(scanButton)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            scanButton.heightAnchor.constraint(equalToConstant: 45),
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        let scanBtnWidth = scanButton.widthAnchor.constraint(equalToConstant: 20)
        scanBtnWidth.priority = UILayoutPriority(250)
        scanBtnWidth.isActive = true
        scanButton.invalidateIntrinsicContentSize()

        scanButton.setTitle("Tap to scan", for: .normal)
        scanButton.invalidateIntrinsicContentSize()
    }

    @objc private func scanTapped() {
        self.nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        self.nfcSession?.begin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

extension HomeViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        print(tags)
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""

        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8) ?? "Format not supported"
        }

        DispatchQueue.main.async {
            self.messageLabel.text = result
        }
    }

    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("nfc read session active \(session)")
    }
}

