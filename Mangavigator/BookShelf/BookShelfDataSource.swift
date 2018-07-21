//
//  BookShelfDataSource.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/22.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

final class BookShelfDataSource: NSObject, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return collectionView.makeItem(withIdentifier: BookItem.identifier, for: indexPath)
    }
}
