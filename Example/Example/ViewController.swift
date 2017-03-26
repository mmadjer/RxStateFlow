//
//  ViewController.swift
//  Example
//
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import UIKit
import RealmSwift
import RxCocoa
import RxRealm
import RxStateFlow
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper! {
        didSet {
            stepper.maximumValue = Double(store.state.value.maxCounterValue)
            stepper.minimumValue = Double(store.state.value.minCounterValue)
        }
    }

    internal var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try? Realm()
        let history = realm!.objects(History.self).first!
        Observable.from(history.records)
            .map { !$0.isEmpty }
            .bindTo(undoButton.rx.isEnabled)
            .addDisposableTo(bag)

        // Subscribe to store changes
        store.state.asDriver().drive(onNext: { state in
            self.updateView(state)
            }).addDisposableTo(bag)
        store.errors.asDriver().drive(onNext: { error in
            self.handleErrors(error)
            }).addDisposableTo(bag)
    }

    // MARK: - Action methods

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        store.dispatch(event: UpdateCounter(value: Int(sender.value)))
    }

    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        store.dispatch(command: IncreaseCounter())
    }

    @IBAction func onSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        store.dispatch(command: IncreaseCounter())
    }

    @IBAction func onSwipeRight(_ sender: UISwipeGestureRecognizer) {
        store.dispatch(command: DecreaseCounter())
    }

    @IBAction func onUndo(_ sender: AnyObject) {
        store.dispatch(event: HistoryEvent.undo)
    }

    @IBAction func onReset(_ sender: AnyObject) {
        store.dispatch(event: CounterEvent.reset)
    }

    // MARK: - Helper methods

    fileprivate func updateView(_ state: AppState) {
        valueLabel.text = String(Int(state.counter))
        stepper.value = Double(state.counter)
    }

    fileprivate func handleErrors(_ error: Error?) {

        if let error = error {
            var message = error.localizedDescription

            switch error {
            case CounterError.minReached:
                message = "Minimum reached"
            case CounterError.maxReached:
                message = "Maximum reached"
            default:
                break
            }

            let alert = UIAlertController(title: "Ooops",
                                          message: message,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                store.dispatch(event: ErrorEvent.remove)
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}
