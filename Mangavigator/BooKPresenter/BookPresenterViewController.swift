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
    private let imageView = NSImageView()


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

        view.addSubview(imageView)

        guard let archive = Archive(url: file, accessMode: .read) else  {
            return
        }

        let firstFile = archive.first { entry in
            entry.type == .file
//            entry.path
        }

        do {
            let path = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(UUID().uuidString)
            try? FileManager.default.removeItem(at: path)
            try archive.extract(firstFile!, to: path)
            imageView.image = NSImage(contentsOf: path)
        }
        catch {
            print(error)
        }
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        imageView.frame = view.bounds
    }
}
