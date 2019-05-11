//
//  TableViewWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class TableViewListWidget<Item>: WidgetBase<UITableView> {

    public typealias ItemAction = (_ tableView: WidgetTableView, _ indexPath: IndexPath, _ item: Item) -> Void

    public var header: Widget?
    public var footer: Widget?

    public var builder: ObservableListBuilder<Item>?
    public var selected: ItemAction?
    public var refresh: ((_ refreshControl: UIRefreshControl) -> Void)?

    public init(_ builder: ObservableListBuilder<Item>) {
        self.builder = builder
        super.init()
    }

    override open func buildInitialView(with context: WidgetContext) -> UITableView? {
        return WidgetTableView(frame: UIScreen.main.bounds)
    }

    override open func applyProperties(to view: UITableView, with context: WidgetContext) {
        guard let tableView = view as? WidgetTableView else { return }

        if #available(iOS 11.0, *) {
            tableView.insetsContentViewsToSafeArea = false
        } // kill default behavior and left safearea widget handle things.

        super.applyProperties(to: tableView, with: context)

        if let builder = self.builder {
            view.register(WidgetTableViewCell.self, forCellReuseIdentifier: "WidgetCell")
            builder.items
                .do(onNext: { [weak tableView] _ in
                    tableView?.refreshControl?.endRefreshing()
                })
                .bind(to: tableView.rx.items) { (tableView, _, item) in
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetCell") as! WidgetTableViewCell
                    cell.backgroundColor = .clear
                    if let widget = builder.widget(for: item) {
                        cell.reset(widget: widget, with: context)
                    }
                    return cell
                }
                .disposed(by: context.disposeBag)
        }

        if let selected = self.selected {
            tableView.rx.modelSelected(Item.self)
                .subscribe(onNext: { [weak tableView] (item) in
                    guard let tableView = tableView, let indexPath = tableView.indexPathForSelectedRow else { return }
                    selected(tableView, indexPath, item)
                })
                .disposed(by: context.disposeBag)
        }

        if let header = header {
            let headerFooterView = UITableViewHeaderFooterView()
            headerFooterView.translatesAutoresizingMaskIntoConstraints = false
            headerFooterView.contentView.add(widget: header, with: context)
            tableView.tableHeaderView = headerFooterView
        }

        if let footer = footer {
            let headerFooterView = UITableViewHeaderFooterView()
            headerFooterView.translatesAutoresizingMaskIntoConstraints = false
            headerFooterView.contentView.add(widget: footer, with: context)
            tableView.tableFooterView = headerFooterView
        }

        if let refresh = refresh {
            tableView.enablePullToRefresh(refresh)
        }
    }

    public func header(_ header: Widget?) -> Self {
        self.header = header
        return self
    }

    public func footer(_ footer: Widget?) -> Self {
        self.footer = footer
        return self
    }

    public func onRefresh(_ refresh: @escaping ((_ refreshControl: UIRefreshControl) -> Void)) -> Self {
        self.refresh = refresh
        return self
    }

    public func onSelected(_ selected: @escaping ItemAction) -> Self {
        self.selected = selected
        return self
    }

}

open class WidgetTableView: UITableView {

    var refresh: ((_ refreshControl: UIRefreshControl) -> Void)?

    open func enablePullToRefresh(_ refresh: @escaping (_ refreshControl: UIRefreshControl) -> Void) {
        self.refresh = refresh
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(callRefresh(_:)), for: .valueChanged)
    }

    @objc private func callRefresh(_ sender: Any) {
        if let control = refreshControl {
            refresh?(control)
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        if let header = tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
            if header.frame.size.height != newSize.height {
                header.frame.size.height = newSize.height
                tableHeaderView = header
            }
        }

        if let footer = tableFooterView {
            let newSize = footer.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
            if footer.frame.size.height != newSize.height {
                footer.frame.size.height = newSize.height
                tableFooterView = footer
            }
        }
    }

    public func deselect() {
        while let indexPath = indexPathForSelectedRow {
            deselectRow(at: indexPath, animated: true)
        }
    }

}

open class WidgetTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()

    override open func prepareForReuse() {
        disposeBag = DisposeBag()
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }

    open func reset(widget: Widget, with context: WidgetContext) {
        var context = context
        context.disposeBag = disposeBag
        contentView.add(widget: widget, with: context)
    }

}
