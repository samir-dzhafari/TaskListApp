//
//  TaskViewController.swift
//  TaskListApp
//
//  Created by brubru on 23.11.2023.
//

import UIKit

protocol ITaskViewController: AnyObject {
	func reloadData()
}

final class TaskViewController: UIViewController {
	
	weak var delegate: ITaskViewController?
	private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	private lazy var taskTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "New Task"
		textField.borderStyle = .roundedRect
		
		textField.translatesAutoresizingMaskIntoConstraints = false
		
		return textField
	}()
	
	private lazy var saveButton: UIButton = {
		let customButtonFactory: ButtonFactory = FilledButtonFactory(
			title: "Save Task",
			color: UIColor(named: "MilkBlue") ?? .white,
			action: UIAction { [unowned self] _ in
				save()
			}
		)
		
		return customButtonFactory.createButton()
	}()
	
	private lazy var cancelButton: UIButton = {
		let customButtonFactory: ButtonFactory = FilledButtonFactory(
			title: "Cansel",
			color: UIColor(named: "MilkRed") ?? .white,
			action: UIAction { [unowned self] _ in
				dismiss(animated: true)
			}
		)
		
		return customButtonFactory.createButton()
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupSubviews(taskTextField, saveButton, cancelButton)
		setupConstraints()
	}
}

//MARK: - Private Methods
private extension TaskViewController {
	func setupSubviews(_ subviews: UIView...) {
		subviews.forEach { subview in
			view.addSubview(subview)
		}
	}
	
	func save() {
		let task = Task(context: viewContext)
		task.title = taskTextField.text
		
		if viewContext.hasChanges {
			do {
				try viewContext.save()
			} catch let error {
				print(error)
			}
		}
		
		delegate?.reloadData()
		dismiss(animated: true)
	}
}

// MARK: - Layout
private extension TaskViewController {
	func setupConstraints() {
		NSLayoutConstraint.activate([
			taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
			taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			
			saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 40),
			saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			
			cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
			cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
		])
	}
}
