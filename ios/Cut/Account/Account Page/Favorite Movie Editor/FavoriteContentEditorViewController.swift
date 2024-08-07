//
//  ReorderableCollectionView.swift
//  Cut
//
//  Created by Kyle Satti on 4/2/24.
//

import UIKit
import SwiftUI
import Combine
import Apollo

class FavoriteContentEditorViewController: UIViewController {
    private var _content: [Content]
    private var content: [Content] {
        set { updateContent(newValue) }
        get { _content }
    }
    let moviesLayout = OneLineCollectionViewLayout()
    let placeholderLayout = PlaceholderLayout()
    lazy var moviesCollectionView = {
        let c = SelfSizingCollectionView(frame: .zero, collectionViewLayout: moviesLayout)
        c.dataSource = self
        c.delegate = self
        c.dragDelegate = self
        c.dropDelegate = self
        c.isScrollEnabled = false
        c.dragInteractionEnabled = isEditable
        c.clipsToBounds = false
        c.backgroundColor = .clear
        c.reorderingCadence = .fast
        c.delaysContentTouches = false
        c.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: "TEST")
        return c
    }()
    lazy var placeholderCollectionView = {
        let c = SelfSizingCollectionView(frame: .zero, collectionViewLayout: placeholderLayout)
        c.dataSource = self
        c.delegate = self
        c.isScrollEnabled = false
        c.backgroundColor = .clear
        c.dragInteractionEnabled = false
        c.delaysContentTouches = false
        c.register(PlaceholderCollectionViewCell.self, forCellWithReuseIdentifier: "TEST")
        return c
    }()
    let contentTapped: (Content) -> Void
    let isEditable: Bool
    var isWobbling = false {
        didSet {
            guard isWobbling != oldValue else { return }
            (moviesCollectionView.visibleCells as! [PosterCollectionViewCell]).forEach { cell in
                cell.updateRemoveButton(isHidden: !isWobbling)
                cell.isWiggling = isWobbling
                if isWobbling {
                    addWiggleToCell(cell)
                } else {
                    cell.layer.removeAllAnimations()
                }
            }
            if !isWobbling {
                save()
            }
        }
    }
    private var inFlightRequest: Apollo.Cancellable?

    init(content: [Content], contentTapped: @escaping (Content) -> Void, isEditable: Bool) {
        _content = []
        self.contentTapped = contentTapped
        self.isEditable = isEditable
        super.init(nibName: nil, bundle: nil)
        updateContent(content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateContent(_ newValue: [Content]) {
        _content = Array(newValue[0..<min(OneLineCollectionViewLayout.maxItems, newValue.count)])
    }

    class CollectionViewContainer: UIView {
        override var intrinsicContentSize: CGSize {
            return subviews[1].intrinsicContentSize
        }
    }

    class SelfSizingCollectionView: UICollectionView {
        override var intrinsicContentSize: CGSize {
            collectionViewLayout.collectionViewContentSize
        }

        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard !hasActiveDrag else { return super.hitTest(point, with: event) }

            let hit = super.hitTest(point, with: event)
            guard hit === self else {
                return hit
            }

            let sibling = superview?
                .subviews
                .filter { $0 !== self }
                .filter { $0.canHit }
                .last { $0.point(inside: convert(point, to: $0), with: event) }

            let target = sibling?.subviews
                .filter { $0.canHit }
                .last { $0.point(inside: convert(point, to: $0), with: event) } ?? sibling

            return target ?? hit
        }
    }

    override func loadView() {
        let collectionViewContainer = CollectionViewContainer(frame: .zero)

        collectionViewContainer.addSubview(placeholderCollectionView)
        collectionViewContainer.addSubview(moviesCollectionView)
        collectionViewContainer.disableAutoresizing()
        let constraint = collectionViewContainer.trailingAnchor.constraint(equalTo: moviesCollectionView.trailingAnchor)
        constraint.priority = UILayoutPriority.init(500)

        NSLayoutConstraint.activate([
            collectionViewContainer.leadingAnchor.constraint(equalTo: moviesCollectionView.leadingAnchor),
            constraint,
            collectionViewContainer.topAnchor.constraint(equalTo: moviesCollectionView.topAnchor),
            collectionViewContainer.bottomAnchor.constraint(equalTo: moviesCollectionView.bottomAnchor),

            collectionViewContainer.leadingAnchor.constraint(equalTo: placeholderCollectionView.leadingAnchor),
            collectionViewContainer.trailingAnchor.constraint(equalTo: placeholderCollectionView.trailingAnchor),
            collectionViewContainer.topAnchor.constraint(equalTo: placeholderCollectionView.topAnchor),
            collectionViewContainer.bottomAnchor.constraint(equalTo: placeholderCollectionView.bottomAnchor),
        ])

        view = collectionViewContainer
    }

    private func getShakeAnimation() -> CAAnimation{
        let animation = CAKeyframeAnimation(keyPath: "transform")
        let wobbleAngle: CGFloat = 0.06

        let leftWobble = NSValue(caTransform3D: CATransform3DMakeRotation(wobbleAngle, 0, 0, 1))
        let rightWobble = NSValue(caTransform3D: CATransform3DMakeRotation(-wobbleAngle, 0, 0, 1))
        animation.values = [leftWobble, rightWobble]

        animation.autoreverses = true
        animation.duration = 0.125
        animation.repeatCount = .infinity

        return animation
    }

    private func addWiggleToCell(_ cell: UIView) {
        cell.layer.removeAllAnimations()
        CATransaction.begin()
        CATransaction.setDisableActions(false)
        cell.layer.add(getShakeAnimation(), forKey: "rotation")
        CATransaction.commit()
    }

    private func save() {
        inFlightRequest?.cancel()
        let contentIds = content.map { $0.id }
        inFlightRequest = AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.UpdateAccountMutation(params: CutGraphQL.UpdateAccountInput(favoriteContent: .some(contentIds)))) { _ in
            self.inFlightRequest = nil
        }
    }

    override var preferredContentSize: CGSize {
        get { view.intrinsicContentSize }
        set { }
    }
}

extension FavoriteContentEditorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moviesCollectionView {
            return content.count
        } else {
            return max(OneLineCollectionViewLayout.maxItems - content.count, 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === moviesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TEST", for: indexPath) as! PosterCollectionViewCell
            let content = content[indexPath.item]
            cell.content = content
            if isWobbling {
                addWiggleToCell(cell)
            }
            if !collectionView.hasActiveDrop {
                cell.updateRemoveButton(isHidden: !isWobbling, animated: false)
            }
            cell.removeAction = { [weak collectionView, weak self] in
                guard let `self` = self, let removedIndex = collectionView?.indexPath(for: cell) else {
                    return
                }
                self.content.remove(at: removedIndex.item)
                collectionView?.performBatchUpdates {
                    collectionView?.deleteItems(at: [removedIndex])
                }
                self.placeholderCollectionView.performBatchUpdates { [weak self] in
                    guard let `self` = self else { return }
                    // 5 to 4 -> insert 0, 4 -> 3 -> insert 1
                    let insertIndex = max(4 - self.content.count, 0)
                    self.placeholderCollectionView.insertItems(at: [IndexPath(item: insertIndex, section: 0)])
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TEST", for: indexPath) as! PlaceholderCollectionViewCell
            cell.displayAdd = isEditable
            return cell
        }
    }
}

extension FavoriteContentEditorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === moviesCollectionView {
            let content = content[indexPath.item]
            contentTapped(content)
        } else if isEditable && collectionView === placeholderCollectionView {
            let vc = ContentSelectionViewController { [weak self] c in
                defer { self?.dismiss(animated: true) }
                guard let `self` = self else { return }
                guard self.content.contains(where: { $0.allIds.contains(c.id) }) == false else { return }
                self.content.append(c)
                self.moviesCollectionView.performBatchUpdates {
                    self.moviesCollectionView.insertItems(at: [IndexPath(item: self.content.count - 1, section: 0)])
                }
                self.placeholderCollectionView.performBatchUpdates {
                    self.placeholderCollectionView.deleteItems(at: [IndexPath(item: 5 - self.content.count, section: 0)])
                }
                self.save()
            }
            self.present(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = false
    }
}

extension FavoriteContentEditorViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = content[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! PosterCollectionViewCell
        cell.updateRemoveButton(isHidden: true, animated: false)
        let provider = NSItemProvider(object: item.title as NSString)
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = item
        dragItem.previewProvider = {
            let params = UIDragPreviewParameters()
            params.backgroundColor = .clear
            return UIDragPreview(view: cell.imageView, parameters: params)
        }
        return [dragItem]
    }

    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        guard isWobbling else { return }
        guard let item = session.items.first?.localObject as? Content else { return }
        guard let index = content.firstIndex(where: { $0.id == item.id }) else { return }
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! PosterCollectionViewCell
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            cell.updateRemoveButton(isHidden: false)
        }
    }
}

extension FavoriteContentEditorViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        if let _ = session.items.first?.localObject as? Content {
            if content.count >= 5 {
                return  UICollectionViewDropProposal(operation: .forbidden)
            }
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: content.count, section: 0)
        guard let item = coordinator.items.first else {
            return
        }
        if let sourceIndex = item.sourceIndexPath {
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            collectionView.performBatchUpdates {
                let movie = content.remove(at: sourceIndex.item)
                collectionView.deleteItems(at: [sourceIndex])
                content.insert(movie, at: destinationIndexPath.item)
                collectionView.insertItems(at: [destinationIndexPath])
            }
        } else if let c = item.dragItem.localObject as? Content {
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            content.insert(c, at: destinationIndexPath.item)
            collectionView.performBatchUpdates {
                collectionView.insertItems(at: [destinationIndexPath])
            }
            placeholderCollectionView.performBatchUpdates {
                placeholderCollectionView.deleteItems(at: [IndexPath(item: 5 - self.content.count, section: 0)])
            }
        }
        if !isWobbling {
            save()
        }
    }

}

extension UIView {
    var canHit: Bool {
        !isHidden && isUserInteractionEnabled && alpha >= 0.01
    }
}

#Preview {
    CoverShelf(content: [Mocks.content, Mocks.content, Mocks.content], contentTapped: { _ in

    }, isEditable: false, isEditing: .constant(false))
}
