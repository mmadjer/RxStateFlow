//
//  HistoryViewController.swift
//  Example
//
//  Created by Miroslav Valkovic-Madjer on 26/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import UIKit
import RealmSwift
import RxStateFlow
import RxSwift
import RxCocoa

class HistoryViewController: UITableViewController {

    @IBOutlet weak var trashButton: UIBarButtonItem!

    internal var bag = DisposeBag()

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let realm = try Realm()
            if let history = realm.objects(History.self).first {

            Observable.from(history.records)
                .map { !$0.isEmpty }
                .bindTo(trashButton.rx.isEnabled)
                .addDisposableTo(bag)

            Observable.from(history.records)
                .bindTo(tableView
                    .rx
                    .items(cellIdentifier: "RecordCell", cellType: RecordCell.self)) {
                        row, record, cell in
                        cell.record = record
                    }
                .addDisposableTo(bag)
            }
        } catch _ { }
    }

    // MARK: - Action methods

    @IBAction func onTrash(_ sender: AnyObject) {
        store.dispatch(event: HistoryEvent.clear)
    }

}

class RecordCell: UITableViewCell {
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var valuesLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!

    var record: HistoryRecord? {
        didSet {
            guard let record = record else { return }

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short

            typeLabel.text = record.type
            timestampLabel.text = dateFormatter.string(from: record.timestamp)

            valuesLabel.text = ""
            if let values = record.raw, !values.isEmpty {
                valuesLabel.text = String(describing: values)
            }
        }
    }

}
