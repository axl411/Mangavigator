//
//  BookPresenterController.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/31.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa
import ZIPFoundation

class BookPresenterViewController: NSViewController {
    private let file: URL
    init(file: URL) {
        self.file = file
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.cyan.cgColor

        guard let archive = Archive(url: file, accessMode: .read) else  {
            return
        }

        let firstFile = archive.first { entry in
            entry.type == .file
//            entry.path
        }

        do {
            try archive.extract(firstFile!) { data in
                let image = NSImage(data: data)!
                let imageView = NSImageView(image: image)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(imageView)
                NSLayoutConstraint.activate([
                    imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                    imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
                    ])
            }
            let path = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(UUID().uuidString)
            try archive.extract(firstFile!, to: path)
            let image = NSImage(contentsOf: path)!
            // TODO: design a mechanism for displaying images in zip file (thumbnails & real image & preloading)

        }
        catch {

        }
    }
}
