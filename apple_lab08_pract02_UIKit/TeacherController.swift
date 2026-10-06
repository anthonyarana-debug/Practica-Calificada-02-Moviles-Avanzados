//
//  TeacherController.swift
//  apple_lab08_pract02_UIKit
//

import UIKit

struct Teacher {
    let name: String
    let subject: String

    var initials: String {
        name.split(separator: " ").prefix(2).compactMap { $0.first }.map { String($0) }.joined()
    }
}

class TeacherController: UIViewController {

    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)

    private let teachers = [
        Teacher(name: "John Doe", subject: "Mathematics"),
        Teacher(name: "Anna Smith", subject: "Physics"),
        Teacher(name: "Robert Johnson", subject: "Chemistry"),
        Teacher(name: "Maria Brown", subject: "Biology"),
        Teacher(name: "David Wilson", subject: "History"),
        Teacher(name: "Emily Garcia", subject: "English"),
        Teacher(name: "Thomas Martinez", subject: "Computer Science"),
        Teacher(name: "Laura Taylor", subject: "Art")
    ]
    private var filtered: [Teacher] = []

    private let colors: [UIColor] = [.systemBlue, .systemOrange, .systemGreen, .systemIndigo,
                                     .systemPink, .systemPurple, .systemTeal, .systemYellow]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Teachers"
        filtered = teachers

        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        view.addSubview(tableView)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // Círculo de color con las iniciales del docente
    private func avatar(for teacher: Teacher, color: UIColor) -> UIImage {
        let size = CGSize(width: 44, height: 44)
        return UIGraphicsImageRenderer(size: size).image { _ in
            color.withAlphaComponent(0.15).setFill()
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: color
            ]
            let text = teacher.initials as NSString
            let textSize = text.size(withAttributes: attributes)
            text.draw(at: CGPoint(x: (size.width - textSize.width) / 2,
                                  y: (size.height - textSize.height) / 2),
                      withAttributes: attributes)
        }
    }
}

extension TeacherController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filtered.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "TeacherCell")
        let teacher = filtered[indexPath.row]
        let color = colors[indexPath.row % colors.count]

        var content = cell.defaultContentConfiguration()
        content.text = teacher.name
        content.textProperties.font = .boldSystemFont(ofSize: 17)
        content.secondaryText = teacher.subject
        content.secondaryTextProperties.color = .secondaryLabel
        content.image = avatar(for: teacher, color: color)
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }
}

extension TeacherController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let text = (searchController.searchBar.text ?? "").trimmingCharacters(in: .whitespaces)
        if text.isEmpty {
            filtered = teachers
        } else {
            filtered = teachers.filter {
                $0.name.localizedCaseInsensitiveContains(text) ||
                $0.subject.localizedCaseInsensitiveContains(text)
            }
        }
        tableView.reloadData()
    }
}
