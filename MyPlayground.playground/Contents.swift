import Cocoa
import PlaygroundSupport

let rootView = NSView(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
rootView.wantsLayer = true
rootView.layer?.backgroundColor = NSColor.yellow.cgColor

let collectionView = NSCollectionView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
collectionView.translatesAutoresizingMaskIntoConstraints = false
collectionView.backgroundColors = [.blue]
//collectionView.wantsLayer = true
//collectionView.layer?.backgroundColor = NSColor.blue.cgColor
rootView.addSubview(collectionView)
NSLayoutConstraint.activate([
    collectionView.topAnchor.constraint(equalTo: rootView.topAnchor),
    collectionView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
    collectionView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
    collectionView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor)
])

class Cell: NSCollectionViewItem {
    static let identifier = String(describing: self)

    override var representedObject: Any? {
        get {
            return super.representedObject
        }

        set {
            super.representedObject = newValue
            print("Set value: \(newValue!)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.red.cgColor
    }
}

collectionView.register(Cell.self, forItemWithIdentifier: .init(Cell.identifier))

let data = [
    1,
    2,
    3
]

class DataSource: NSObject, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        itemForRepresentedObjectAt indexPath: IndexPath
    ) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .init(Cell.identifier), for: indexPath)
        item.representedObject = data[indexPath.item]
        return item
    }
}

let dataSource = DataSource()
collectionView.dataSource = dataSource

let layout = NSCollectionViewFlowLayout()
layout.minimumLineSpacing = 10
layout.itemSize = NSSize(width: 50, height: 50)
collectionView.collectionViewLayout = layout

//PlaygroundPage.current.needsIndefiniteExecution
PlaygroundPage.current.liveView = rootView
