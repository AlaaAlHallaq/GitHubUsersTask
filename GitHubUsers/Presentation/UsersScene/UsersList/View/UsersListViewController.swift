//
//  UsersListViewController.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import UIKit

final class UsersListViewController: UITableViewController {
    private var viewModel: UsersListViewModel!

    // MARK: - Lifecycle

    static func create(with viewModel: UsersListViewModel) -> UsersListViewController {
        let view = UsersListViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }

    private func bind(to viewModel: UsersListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.tableView.reloadData() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewWillAppear()
    }

    // MARK: - Private

    private func setupViews() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = UserItemViewCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(
            UserItemViewCell.self,
            forCellReuseIdentifier: UserItemViewCell.reuseIdentifier
        )

        title = LocalizedText.githubUsers.value
        tableView.refreshControl = UIRefreshControl().with {
            $0.addTarget(self, action: #selector(onReloadPage), for: .valueChanged)
        }
        addChangeLanguageButton()
    }

    @objc private func onReloadPage(_ refresh: UIRefreshControl) {
        viewModel.viewWillAppear()
        refresh.endRefreshing()
    }

    // This code can be moved to appearnce abstraction folder
    // Added to show the localization & UI direction
    func addChangeLanguageButton() {
        let logoutBarButtonItem = UIBarButtonItem(
            title: LocalizedText.otherLangAbbr.value,
            style: .done,
            target: self,
            action: #selector(onChangeLanguageClicked)
        )
        self.navigationItem.rightBarButtonItem = logoutBarButtonItem
    }

    @objc func onChangeLanguageClicked() {
        guard
            let window = (UIApplication
                .shared.delegate as? AppDelegate)?.window
        else { return }

        LanguageHelper.setLanguage(to: isAR ? "en" : "ar")
        LanguageHelper.refreshUI()

        let nav = UINavigationController()
            .with {
                $0.view.backgroundColor = .white
            }

        UsersFlowCoordinator(navigationController: nav)
            .start()

        UIView.transition(
            with: window,
            duration: 0.55,
            options: isAR ? .transitionFlipFromLeft : .transitionFlipFromRight,
            animations: {
                window.rootViewController = nav
            },
            completion: { _ in }
        )
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension UsersListViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.shouldFetchNextPage(threshould: 1) {
            // NOTE: can use this to fetch next page !!
            viewModel.nextPage()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserItemViewCell.reuseIdentifier, for: indexPath) as? UserItemViewCell else {
            assertionFailure("Cannot dequeue reusable cell \(UserItemViewCell.self) with reuseIdentifier: \(UserItemViewCell.reuseIdentifier)")
            return UITableViewCell()
        }
        cell.fill(with: viewModel.items.value[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelect(item: viewModel.items.value[indexPath.row])
    }
}
