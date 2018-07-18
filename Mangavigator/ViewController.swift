//
//  ViewController.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/17.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    private let collectionView: NSCollectionView = {
        let collectionView = NSCollectionView()
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer?.backgroundColor = NSColor.yellow.cgColor
        
        view.addSubview(collectionView)
        collectionView.addConstraints(
            [
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                // TODO: experiment with NSCollectionView
                // TODO: learn auto layout
            ]
        )
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

