import UIKit

/// Конфигурация ячейки с количеством отзывов
struct ReviewCountCellConfig {
    
    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: ReviewCountCellConfig.self)
    ///  Текст с количеством отзывов
    let reviewCountText: NSAttributedString
    
    /// Объект, хранящий посчитанные фреймы для ячейки с количеством отзывов
    fileprivate let layout = ReviewCountCellLayout()
}

// MARK: - TableCellConfig

extension ReviewCountCellConfig: TableCellConfig {
    
    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCountCell else { return }
        cell.reviewCountLabel.attributedText = reviewCountText
        cell.config = self
    }
    
    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }
    
}

// MARK: - Cell

final class ReviewCountCell: UITableViewCell {
    
    fileprivate var config: Config?
    
    fileprivate let reviewCountLabel = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        reviewCountLabel.frame = layout.reviewCountLabelFrame
    }
    
}

// MARK: - Private

private extension ReviewCountCell {
    
    func setupCell() {
        setupCountLabel()
    }
    
    func setupCountLabel() {
        contentView.addSubview(reviewCountLabel)
        reviewCountLabel.textAlignment = .center
    }
}

// MARK: - Layout

/// Класс, в котором происходит расчёт фреймов для сабвью ячейки отзыва.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewCountCellLayout {
    
    // MARK: - Фреймы
    private(set) var reviewCountLabelFrame = CGRect.zero
    
    // MARK: - Отступы
    
    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 16.0, bottom: 9.0, right: 16.0)
    
    // MARK: - Расчёт фреймов и высоты ячейки
    
    /// Возвращает высоту ячейку с данной конфигурацией `config` и ограничением по ширине `maxWidth`.
    func height(config: Config, maxWidth: CGFloat) -> CGFloat {
        let width = maxWidth - insets.left - insets.right
        var maxY = insets.top
        
        // Расчет размера текста
        let textSize = config.reviewCountText.boundingRect(width: width,
                                                           height: .greatestFiniteMagnitude)
        
        // Расчет фрейма для  текста
        reviewCountLabelFrame = CGRect(x: insets.left,
                                 y: insets.top,
                                 width: width,
                                 height: textSize.height
        )
        
        maxY = reviewCountLabelFrame.maxY
        
        return maxY + insets.bottom
    }
    
}

// MARK: - Typealias

fileprivate typealias Config = ReviewCountCellConfig
fileprivate typealias Layout = ReviewCountCellLayout
