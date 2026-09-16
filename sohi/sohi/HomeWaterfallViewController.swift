//
//  HomeWaterfallViewController.swift
//  sohi
//
//  类似小红书首页的双列卡片页：UICollectionView + 自定义瀑布流布局
//

import UIKit

// MARK: - 数据模型

struct CardItem {
    let icon: String        // SF Symbol 名
    let color: UIColor      // 图标颜色
    let imageHeight: CGFloat
}

// MARK: - 卡片 Cell

final class CardCell: UICollectionViewCell {
    static let reuseID = "CardCell"

    private let iconView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        iconView.contentMode = .center
        contentView.addSubview(iconView)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with item: CardItem) {
        let config = UIImage.SymbolConfiguration(pointSize: 36)
        iconView.image = UIImage(systemName: item.icon, withConfiguration: config)
        iconView.tintColor = item.color
        // iconView.backgroundColor = .systemGreen
        contentView.backgroundColor = item.color.withAlphaComponent(0.12)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = contentView.bounds
    }
}

// MARK: - 页面控制器

final class HomeWaterfallViewController: UIViewController {

    // 30 个卡片数据，高度固定公式生成，滑动时视觉上有长短交错的瀑布流效果
    private static let icons = ["heart.fill", "star.fill", "flame.fill", "leaf.fill", "bolt.fill",
                                "moon.fill", "sun.max.fill", "cloud.fill", "drop.fill", "gift.fill"]
    private static let colors: [UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemMint,
                                            .systemTeal, .systemBlue, .systemIndigo, .systemPurple, .systemPink]

    private let items: [CardItem] = (0..<30).map { i in
        CardItem(icon: HomeWaterfallViewController.icons[i % HomeWaterfallViewController.icons.count],
                 color: HomeWaterfallViewController.colors[i % HomeWaterfallViewController.colors.count],
                 imageHeight: 120 + CGFloat((i * 37) % 100))
    }

    private lazy var cv = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    // 相当于执行过 layout.collectionView = self   // self = 刚创建的 UICollectionView

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        cv.frame = view.bounds
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cv.backgroundColor = .clear // 设成透明，让底下 view 的 systemGroupedBackground 透出来
        cv.dataSource = self
        cv.register(CardCell.self, forCellWithReuseIdentifier: CardCell.reuseID)
        view.addSubview(cv)
    }

    private func makeLayout() -> WaterfallLayout {
        let layout = WaterfallLayout()
        layout.delegate = self
        return layout
    }
}

// MARK: - UICollectionViewDataSource

extension HomeWaterfallViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseID, for: indexPath) as! CardCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - WaterfallLayoutDelegate

extension HomeWaterfallViewController: WaterfallLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        layout: WaterfallLayout,
                        heightForItemAt indexPath: IndexPath,
                        itemWidth: CGFloat) -> CGFloat {
        items[indexPath.item].imageHeight
    }
}
