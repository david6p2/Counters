//
//  ExamplesView.swift
//  Counters
//
//  Created by David A Cespedes R on 5/1/21.
//

import UIKit

internal final class ExamplesView: UIView {

    // MARK: - Properties

    private var viewModel: ExamplesViewModel!
    private let headerLabel = UILabel()
    private let shadowView = UIView()
    private var examplesColectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<String, String>! = nil

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with viewModel: ExamplesViewModel) {
        self.viewModel = viewModel
        configureHeaderLabel(with: viewModel)
        configureDataSource(with: viewModel)
    }
}

extension ExamplesView {
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Constants.interSectionSpacing

        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            // Cell Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(200),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(Constants.horizontalEdgeSpacing),
                                                             top: nil,
                                                             trailing: nil,
                                                             bottom: nil)

            // Cell per SectionGroup
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(200),
                                                   heightDimension: .absolute(55.0))
            let itemsGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                    subitems: [item])

            // Section
            let section = NSCollectionLayoutSection(group: itemsGroup)
            section.interGroupSpacing = Constants.interGroupSpacing
            section.orthogonalScrollingBehavior = .continuous

            // Section Header
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(57)),
                elementKind: Constants.headerElementKind,
                alignment: .top)

            sectionHeader.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(Constants.horizontalEdgeSpacing),
                                                                      top: nil,
                                                                      trailing: .fixed(Constants.horizontalEdgeSpacing),
                                                                      bottom: nil)

            section.boundarySupplementaryItems = [sectionHeader]

            return section

        }, configuration: config)
        return layout
    }
}

extension ExamplesView {

    func configureHeaderLabel(with viewModel: ExamplesViewModel) {
        headerLabel.attributedText = .init(string: viewModel.examplesHeaderString,
                                             attributes: [.kern: Font.viewHeaderKern])
        headerLabel.textColor = UIColor.secondaryText
    }

    func configureDataSource(with viewModel: ExamplesViewModel) {

        // Only available for iOS 14 and above.
        // Will need to implement `register(_:forCellWithReuseIdentifier:)` if support for iOS 13 and below is needed.
        let cellRegistration = UICollectionView.CellRegistration<ExampleCellView, String> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.label.attributedText = .init(string: identifier,
                                              attributes: [.kern: Font.cellTitleKern])
            cell.contentView.backgroundColor = .cellBackground
            cell.contentView.cornerRadius(radius: Constants.cellCornerRadius)
            cell.label.textAlignment = .center
            cell.label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: Font.cellTitle)

            cell.clipsToBounds = true
            cell.layer.shadowRadius = Shadow.radius
            cell.layer.shadowColor = Shadow.color
            cell.layer.shadowOffset = Shadow.offset
            cell.layer.shadowOpacity = Shadow.opacity
        }

        dataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: examplesColectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        // Header Registration
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <ExampleHeaderCellView>(elementKind: Constants.headerElementKind) {
            (supplementaryView, string, indexPath) in
            let title = viewModel.examplesViewModel[indexPath.section].sectionTitle
            supplementaryView.label.attributedText = .init(string: title,
                                                           attributes: [.kern: Font.cellHeaderKern])
            supplementaryView.label.textColor = .subtitleText
            supplementaryView.label.font = UIFontMetrics(forTextStyle: .title2).scaledFont(for: Font.cellHeader)
        }

        // Assign the Header
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.examplesColectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }

        // Initial data
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        viewModel.examplesViewModel.forEach { (viewModel) in
            snapshot.appendSections([viewModel.sectionTitle])
            snapshot.appendItems(viewModel.sectionExamples)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ExamplesView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Cell is \(viewModel.examplesViewModel[indexPath.section].sectionExamples[indexPath.row])")
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Private Constants

private extension ExamplesView {
    enum Constants {
        static let cellCornerRadius: CGFloat = 8
        static let interGroupSpacing: CGFloat = 3
        static let interSectionSpacing: CGFloat = 3
        static let horizontalEdgeSpacing: CGFloat = 15
        static let cellHeight: CGFloat = 55
        static let headerElementKind = "header-element-kind"
    }

    enum Font {
        static let viewHeaderKern: CGFloat = 0.3
        static let cellHeaderKern: CGFloat = 0.52
        static let cellTitleKern: CGFloat = 0.34
        static let viewHeader = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let cellHeader = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let cellTitle = UIFont.systemFont(ofSize: 17, weight: .regular)
    }

    enum Shadow {
        static let opacity: Float = 1
        static let radius: CGFloat = 16
        static let offset = CGSize(width: 0, height: 4)
        static let color = UIColor(white: 0, alpha: 0.02).cgColor
        static let viewColor = UIColor(white: 0, alpha: 0.1)
    }
}

// MARK: - Private Implementation

private extension ExamplesView {
    func setup() {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .systemBackground
        setupHeaderLabel()
        setupShadowView()
        setupCollectionView()
        setupViewHierarchy()
        setupConstraints()
    }

    func setupHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Font.viewHeader)
        headerLabel.textAlignment = .center
        headerLabel.backgroundColor = .background
    }

    func setupShadowView() {
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = Shadow.viewColor
    }

    func setupCollectionView() {
        examplesColectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
        examplesColectionView.translatesAutoresizingMaskIntoConstraints = false
        examplesColectionView.backgroundColor = .background
        examplesColectionView.delegate = self
    }

    func setupViewHierarchy() {
        addSubview(headerLabel)
        addSubview(shadowView)
        addSubview(examplesColectionView)
    }

    func setupConstraints() {
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // Title label
            headerLabel.topAnchor.constraint(equalTo: guide.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 50),

            // Shadow View
            shadowView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            shadowView.heightAnchor.constraint(equalToConstant: 1),

            // Collectiion View
            examplesColectionView.topAnchor.constraint(equalTo: shadowView.bottomAnchor),
            examplesColectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            examplesColectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            examplesColectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
}
