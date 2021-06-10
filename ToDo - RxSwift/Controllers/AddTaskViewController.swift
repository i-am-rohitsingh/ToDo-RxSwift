//
//  AddTaskViewController.swift
//  ToDo - RxSwift
//
//  Created by Rohit Kumar on 07/06/21.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable:Observable<Task>{
        return taskSubject.asObservable()
    }
    
    @IBOutlet weak var prioritySegmentedController: UISegmentedControl!
    @IBOutlet weak var taskTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func save(){
        guard let priority = Priority(rawValue: self.prioritySegmentedController.selectedSegmentIndex), let title = taskTextView.text else {
            return
        }
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
