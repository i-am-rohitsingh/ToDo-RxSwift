//
//  TaskListViewController.swift
//  ToDo - RxSwift
//
//  Created by Rohit Kumar on 23/05/21.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks: [Task] = [Task]()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addVC = segue.destination as? AddTaskViewController else {
            fatalError("Controller not found...")
        }
        
        addVC.taskSubjectObservable
            .subscribe(onNext:{ [unowned self] task in
                
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                self.filterTask(by: priority)
                print(existingTasks)
            }).disposed(by: disposeBag)
    }
    
    func filterTask(by priority: Priority?){
        if priority == nil{
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        }else{
            self.tasks.map{ tasks in
                return tasks.filter{$0.priority == priority!}
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl){
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTask(by: priority)
    }
}

extension TaskListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = filteredTasks[indexPath.row].title
        return cell
    }
    
}
