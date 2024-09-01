//
//  OrderVC.swift
//  FoodApp
//

import UIKit

final class OrderVC: UIViewController {

    private let order: OrderEntity
    
    private lazy var backButtonView: NavigationBarButtonView = {
        let view = NavigationBarButtonView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        view.addGestureRecognizer(tapGesture)
        view.configureAsBackButton()
        return view
    }()
    
    // MARK: - Order info section
    
    private lazy var orderInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.lightGraySectionColor
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 500])
        label.text = "Status"
        return label
    }()
    
    private lazy var statusValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.text = order.status
        return label
    }()
    
    private lazy var orderDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 500])
        label.text = "Order date"
        return label
    }()
    
    private lazy var orderDateValueLabel: UILabel = {
        let label = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = formatter.string(from: order.orderDate!)
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var orderTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 500])
        label.text = "Order time"
        return label
    }()
    
    private lazy var orderTimeValueLabel: UILabel = {
        let label = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = formatter.string(from: order.orderDate!)
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 500])
        label.text = "Address"
        return label
    }()
    
    private lazy var addressValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.text = order.address
        return label
    }()
    
    private lazy var paymentMethodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 500])
        label.text = "Payment Method"
        return label
    }()
    
    private lazy var paymentMethodValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.text = order.paidByCard ? "Card" : "Cash"
        return label
    }()
    
    // MARK: - Order comments
    
    private lazy var commentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.lightGraySectionColor
        view.layer.cornerRadius = 24
        view.isHidden = true
        return view
    }()
    
    private lazy var commentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 500])
        label.text = "Comments"
        return label
    }()
    
    private lazy var commentsValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.text = order.orderComments
        return label
    }()
    
    // MARK: - Order items section
    
    // name
    // quantity
    // price
    
    // MARK: - Bill details section
    
    // productCost
    // deliveryCharge
    // promoCodeDiscount
    // totalAmount
    
    // MARK: - Lifecycle methods
    
    init(order: OrderEntity) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupNavBar() {
        title = "Order"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.shared.label,
            .font: UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [Constants.fontWeightAxis : 650])
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        let backBarButtonItem = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(orderInfoView)
        orderInfoView.addSubview(statusLabel)
        orderInfoView.addSubview(statusValueLabel)
        orderInfoView.addSubview(orderDateLabel)
        orderInfoView.addSubview(orderDateValueLabel)
        orderInfoView.addSubview(orderTimeLabel)
        orderInfoView.addSubview(orderTimeValueLabel)
        orderInfoView.addSubview(addressLabel)
        orderInfoView.addSubview(addressValueLabel)
        orderInfoView.addSubview(paymentMethodLabel)
        orderInfoView.addSubview(paymentMethodValueLabel)
        
        view.addSubview(commentsView)
        commentsView.addSubview(commentsLabel)
        commentsView.addSubview(commentsValueLabel)
        
        if let comments = order.orderComments, !comments.isEmpty {
            commentsView.isHidden = false
        }
        
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // Order info section
            orderInfoView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 32),
            orderInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orderInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            statusLabel.topAnchor.constraint(equalTo: orderInfoView.topAnchor, constant: 24),
            statusLabel.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 24),
            statusValueLabel.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor),
            statusValueLabel.trailingAnchor.constraint(equalTo: orderInfoView.trailingAnchor, constant: -24),
            statusValueLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 16),
            
            orderDateLabel.topAnchor.constraint(equalTo: statusValueLabel.bottomAnchor, constant: 12),
            orderDateLabel.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 24),
            orderDateValueLabel.centerYAnchor.constraint(equalTo: orderDateLabel.centerYAnchor),
            orderDateValueLabel.trailingAnchor.constraint(equalTo: orderInfoView.trailingAnchor, constant: -24),
            orderDateValueLabel.leadingAnchor.constraint(equalTo: orderDateLabel.trailingAnchor, constant: 16),
            
            orderTimeLabel.topAnchor.constraint(equalTo: orderDateLabel.bottomAnchor, constant: 12),
            orderTimeLabel.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 24),
            orderTimeValueLabel.centerYAnchor.constraint(equalTo: orderTimeLabel.centerYAnchor),
            orderTimeValueLabel.trailingAnchor.constraint(equalTo: orderInfoView.trailingAnchor, constant: -24),
            orderTimeValueLabel.leadingAnchor.constraint(equalTo: orderTimeLabel.trailingAnchor, constant: 16),
            
            addressLabel.topAnchor.constraint(equalTo: orderTimeLabel.bottomAnchor, constant: 12),
            addressLabel.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 24),
            addressValueLabel.centerYAnchor.constraint(equalTo: addressLabel.centerYAnchor),
            addressValueLabel.trailingAnchor.constraint(equalTo: orderInfoView.trailingAnchor, constant: -24),
            addressValueLabel.leadingAnchor.constraint(equalTo: addressLabel.trailingAnchor, constant: 16),
            
            paymentMethodLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12),
            paymentMethodLabel.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 24),
            paymentMethodLabel.bottomAnchor.constraint(equalTo: orderInfoView.bottomAnchor, constant: -24),
            paymentMethodValueLabel.centerYAnchor.constraint(equalTo: paymentMethodLabel.centerYAnchor),
            paymentMethodValueLabel.trailingAnchor.constraint(equalTo: orderInfoView.trailingAnchor, constant: -24),
            paymentMethodValueLabel.leadingAnchor.constraint(equalTo: paymentMethodLabel.trailingAnchor, constant: 16),
            
            // Order commetns
            commentsView.topAnchor.constraint(equalTo: orderInfoView.bottomAnchor, constant: 32),
            commentsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commentsLabel.topAnchor.constraint(equalTo: commentsView.topAnchor, constant: 24),
            commentsLabel.leadingAnchor.constraint(equalTo: commentsView.leadingAnchor, constant: 24),
            commentsValueLabel.topAnchor.constraint(equalTo: commentsLabel.topAnchor, constant: 24),
            commentsValueLabel.leadingAnchor.constraint(equalTo: commentsView.leadingAnchor, constant: 24),
            commentsValueLabel.trailingAnchor.constraint(equalTo: commentsView.trailingAnchor, constant: -24),
            commentsValueLabel.bottomAnchor.constraint(equalTo: commentsView.bottomAnchor, constant: -24),
            
            // Order items section
            
        ])
    }
    
    // MARK: - Objc methods
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension OrderVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
