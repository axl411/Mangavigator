//
//  BookShelfViewController.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/22.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

final class BookShelfViewController: NSViewController {

    private let scrollView = NSScrollView(frame: .zero)
    private let collectionView: NSCollectionView = {
        let collectionView = NSCollectionView(frame: NSRect.zero)
        // CocoaPitfalls: setting collectionViewLayout needs to be before registering an
        // Item class or else an exception of '-[NSNib _initWithNibNamed:bundle:options:]
        // could not load the nibName: BookItem in bundle ...' will be thrown when the
        // DataSource is trying to make an item.
        collectionView.collectionViewLayout = NSCollectionViewFlowLayout()
        collectionView.register(BookItem.self, forItemWithIdentifier: BookItem.identifier)
        return collectionView
    }()
    private let dataSource = BookShelfDataSource()

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.addSubview(scrollView)

        scrollView.documentView = self.collectionView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])

        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
}

extension BookShelfViewController: NSCollectionViewDelegate {
}

extension BookShelfViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> NSSize {
        return NSSize(width: 200, height: 300)
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        insetForSectionAt section: Int
    ) -> NSEdgeInsets {
        let inset: CGFloat = 50
        return NSEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 50
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 25
    }
}
