//
//  CalculatorController.swift
//  apple_lab08_pract02_UIKit
//

import UIKit

class CalculatorController: UIViewController {

    private let firstField = UITextField()
    private let secondField = UITextField()
    private let operationButton = UIButton(type: .system)
    private var operation: MathOperation = .addition

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calculator"
        view.backgroundColor = .systemGroupedBackground
        setupUI()
        updateOperationMenu()
    }

    private func setupUI() {
        // Tarjeta blanca
        let card = UIView()
        card.backgroundColor = .systemBackground
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)

        let header = UILabel()
        header.text = "Math Operation"
        header.font = .boldSystemFont(ofSize: 20)
        header.textAlignment = .center

        configure(firstField, placeholder: "First Number")
        configure(secondField, placeholder: "Second Number")

        var buttonConfig = UIButton.Configuration.gray()
        buttonConfig.baseForegroundColor = .label
        operationButton.configuration = buttonConfig
        operationButton.contentHorizontalAlignment = .leading
        operationButton.showsMenuAsPrimaryAction = true

        var calcConfig = UIButton.Configuration.filled()
        calcConfig.title = "Calculate"
        calcConfig.cornerStyle = .capsule
        let calculateButton = UIButton(configuration: calcConfig)
        calculateButton.addTarget(self, action: #selector(calculateTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [header, firstField, secondField, operationButton, calculateButton])
        stack.axis = .vertical
        stack.spacing = 16
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

            firstField.heightAnchor.constraint(equalToConstant: 44),
            secondField.heightAnchor.constraint(equalToConstant: 44),
            operationButton.heightAnchor.constraint(equalToConstant: 44),
            calculateButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        // Cerrar el teclado al tocar fuera
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func configure(_ field: UITextField, placeholder: String) {
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.keyboardType = .numbersAndPunctuation
    }

    private func updateOperationMenu() {
        operationButton.configuration?.title = operation.title
        let actions = MathOperation.allCases.map { op in
            UIAction(title: op.title, state: op == operation ? .on : .off) { [weak self] _ in
                self?.operation = op
                self?.updateOperationMenu()
            }
        }
        operationButton.menu = UIMenu(children: actions)
    }

    // Convierte el texto a número (acepta coma o punto decimal)
    private func number(from field: UITextField) -> Double? {
        let text = (field.text ?? "").replacingOccurrences(of: ",", with: ".")
        return Double(text.trimmingCharacters(in: .whitespaces))
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func calculateTapped() {
        view.endEditing(true)

        guard let a = number(from: firstField), let b = number(from: secondField) else {
            showAlert("Enter two valid numbers.")
            return
        }
        guard let result = operation.apply(a, b) else {
            showAlert("You can't divide by zero.")
            return
        }

        let resultVC = ResultController(operation: operation, first: a, second: b, result: result)
        resultVC.onNewCalculation = { [weak self] in
            self?.firstField.text = ""
            self?.secondField.text = ""
        }
        navigationController?.pushViewController(resultVC, animated: true)
    }
}
