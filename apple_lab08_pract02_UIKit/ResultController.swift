//
//  ResultController.swift
//  apple_lab08_pract02_UIKit
//

import UIKit

class ResultController: UIViewController {

    private let operation: MathOperation
    private let first: Double
    private let second: Double
    private let result: Double

    // Se llama al pulsar "New Calculation" para limpiar la calculadora
    var onNewCalculation: (() -> Void)?

    init(operation: MathOperation, first: Double, second: Double, result: Double) {
        self.operation = operation
        self.first = first
        self.second = second
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Result"
        view.backgroundColor = .systemGroupedBackground
        setupUI()
    }

    private func setupUI() {
        let card = UIView()
        card.backgroundColor = .systemBackground
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)

        let header = UILabel()
        header.text = "Calculation Result"
        header.font = .boldSystemFont(ofSize: 20)
        header.textAlignment = .center

        let separator = UIView()
        separator.backgroundColor = .separator
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let resultTitle = UILabel()
        resultTitle.text = "Result:"
        resultTitle.font = .boldSystemFont(ofSize: 17)
        resultTitle.textColor = .secondaryLabel

        let resultLabel = UILabel()
        resultLabel.text = result.formatted
        resultLabel.font = .boldSystemFont(ofSize: 36)
        resultLabel.textColor = .systemBlue
        resultLabel.textAlignment = .center
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0.5

        let resultBox = UIView()
        resultBox.backgroundColor = .systemGroupedBackground
        resultBox.layer.cornerRadius = 10
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultBox.addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: resultBox.topAnchor, constant: 12),
            resultLabel.bottomAnchor.constraint(equalTo: resultBox.bottomAnchor, constant: -12),
            resultLabel.leadingAnchor.constraint(equalTo: resultBox.leadingAnchor, constant: 12),
            resultLabel.trailingAnchor.constraint(equalTo: resultBox.trailingAnchor, constant: -12)
        ])

        var shareConfig = UIButton.Configuration.filled()
        shareConfig.title = "Share"
        shareConfig.cornerStyle = .capsule
        let shareButton = UIButton(configuration: shareConfig)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)

        var newConfig = UIButton.Configuration.bordered()
        newConfig.title = "New Calculation"
        newConfig.cornerStyle = .capsule
        let newButton = UIButton(configuration: newConfig)
        newButton.addTarget(self, action: #selector(newCalculationTapped), for: .touchUpInside)

        let buttons = UIStackView(arrangedSubviews: [shareButton, newButton])
        buttons.spacing = 12
        buttons.distribution = .fillEqually

        let stack = UIStackView(arrangedSubviews: [
            header,
            row("Operation:", operation.title),
            row("First Number:", first.formatted),
            row("Second Number:", second.formatted),
            separator,
            resultTitle,
            resultBox,
            buttons
        ])
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),

            shareButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // Fila "etiqueta ........ valor"
    private func row(_ title: String, _ value: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .secondaryLabel
        titleLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true

        let valueLabel = UILabel()
        valueLabel.text = value

        let row = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        row.spacing = 8
        return row
    }

    @objc private func shareTapped() {
        let text = "\(first.formatted) \(operation.title) \(second.formatted) = \(result.formatted)"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = view
        present(activity, animated: true)
    }

    @objc private func newCalculationTapped() {
        onNewCalculation?()
        navigationController?.popViewController(animated: true)
    }
}
