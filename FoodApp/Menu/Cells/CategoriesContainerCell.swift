//
//  CategoriesContainerCell.swift
//  FoodApp
//

import UIKit

final class CategoriesContainerCell: UICollectionViewCell {
    static let id = "CategoriesContainerCell"
    
    var categoriesSnapshot = NSDiffableDataSourceSnapshot<Int, String>() {
        didSet {
            selectedStates = []
            categoriesSnapshot.itemIdentifiers.forEach { _ in
                selectedStates.append(false)
            }
            if !selectedStates.isEmpty {
                selectedStates[0] = true
            }
            dataSource.apply(categoriesSnapshot, animatingDifferences: true)
        }
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    private var selectedStates: [Bool] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.id)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.frame = bounds
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView) { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.id, for: indexPath) as? CategoryCell 
            else { fatalError("Unable deque CategoryCell") }
            
            cell.category.setTitle(item, for: .normal)
            cell.category.frame = cell.bounds
            
            if self.selectedStates[indexPath.item] {
                cell.setSelected()
            } else {
                cell.setUnselected()
            }
            
            cell.categorySwitchHandler = { [weak self] in
                self?.unselectAllCategories()
                self?.selectedStates[indexPath.item] = true
                collectionView.reloadData()
            }
            
            return cell
        }
        
        dataSource.apply(categoriesSnapshot, animatingDifferences: true)
    }
    
    private func unselectAllCategories() {
        for index in 0..<selectedStates.count {
            selectedStates[index] = false
        }
    }
    
}

extension CategoriesContainerCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension CategoriesContainerCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = categoriesSnapshot.itemIdentifiers[indexPath.item]
        let font = UIFont(name: "Raleway", size: 14)!
        let titleWidth = NSString(string: title).width(withFont: font)
        return CGSize(width: titleWidth + 32, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
