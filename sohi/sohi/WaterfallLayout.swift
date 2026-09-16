//
//  WaterfallLayout.swift
//  sohi
//
//  自定义双列瀑布流布局：每个 cell 放进当前高度最矮的那一列
//

import UIKit

/// 由外部告诉布局"每个 cell 应该多高"
protocol WaterfallLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
                        layout: WaterfallLayout,
                        heightForItemAt indexPath: IndexPath,
                        itemWidth: CGFloat) -> CGFloat
}

final class WaterfallLayout: UICollectionViewLayout {

    weak var delegate: WaterfallLayoutDelegate?

    var numberOfColumns: CGFloat = 2
    var columnSpacing: CGFloat = 10      // 列间距
    var rowSpacing: CGFloat = 10         // 行间距
    var sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    private var attributesList: [UICollectionViewLayoutAttributes] = []
    private var columnHeights: [CGFloat] = []   // 每一列当前累计高度
    private var cachedContentWidth: CGFloat = 0

    // MARK: - 布局计算

    override func prepare() {
        NSLog("WaterfallLayout prepare 被调用")
        super.prepare()
        guard let collectionView else { return }

        let inset = collectionView.contentInset // 内外两框之间留白的"厚度"
        let contentWidth = collectionView.bounds.width - inset.left - inset.right // 从外框宽推出内框宽
        guard contentWidth > 0 else { return }


        // inSection 这个参数对应 collectionView 的"分区"概念——像通讯录那种 A-Z 分组就是多个 section。
        let itemCount = collectionView.numberOfItems(inSection: 0) // 问第 0 个 section
        // 如果宽度没变且已经算过，直接复用结果
        if cachedContentWidth == contentWidth, attributesList.count == itemCount { return }
        cachedContentWidth = contentWidth

        attributesList.removeAll(keepingCapacity: true)
        let columnWidth = (contentWidth - sectionInset.left - sectionInset.right
                           - columnSpacing * (numberOfColumns - 1)) / numberOfColumns
        columnHeights = Array(repeating: sectionInset.top, count: Int(numberOfColumns))

        for item in 0..<itemCount {
            let indexPath = IndexPath(item: item, section: 0)

            // 找到当前最矮的那一列
            let column = columnHeights.indices.min(by: { columnHeights[$0] < columnHeights[$1] }) ?? 0

            // 第一行不需要再加行间距
            let isFirstRow = columnHeights[column] == sectionInset.top
            let y = isFirstRow ? sectionInset.top : columnHeights[column] + rowSpacing
            let x = sectionInset.left + CGFloat(column) * (columnWidth + columnSpacing)

            let height = delegate?.collectionView(collectionView,
                                                  layout: self,
                                                  heightForItemAt: indexPath,
                                                  itemWidth: columnWidth) ?? columnWidth

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: x, y: y, width: columnWidth, height: height)
            attributesList.append(attributes)

            columnHeights[column] = attributes.frame.maxY
        }
    }

    override var collectionViewContentSize: CGSize {
        // NSLog("WaterfallLayout collectionViewContentSize 被调用")
        guard let collectionView else { return .zero }
        let inset = collectionView.contentInset
        let height = (columnHeights.max() ?? sectionInset.top) + sectionInset.bottom
        return CGSize(width: collectionView.bounds.width - inset.left - inset.right,
                      height: height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // NSLog("WaterfallLayout layoutAttributesForElements 被调用")
        return attributesList.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // NSLog("WaterfallLayout layoutAttributesForItem 被调用")
        guard indexPath.item < attributesList.count else { return nil }
        return attributesList[indexPath.item]
    }

    // 宽度变化（如转屏）时重新布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView else { return true }
        let newWidth = newBounds.width - collectionView.contentInset.left - collectionView.contentInset.right
        return newWidth != cachedContentWidth
    }
}
