//
//  TabBarVC.swift
//  FoodApp
//

import UIKit

final class CartTabVC: UIViewController {
    
    lazy var cartContent: [CartItem] = [] {
        didSet {
            calculateTheBill()
            tableView.reloadData()
            updateTableViewHeight()
        }
    }
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let fontWeightAxis = 2003265652
    private var tableViewHeightConstraint: NSLayoutConstraint?

    private var productPrice: Double = 0
    private var deliveryPrice: Double = 2.0
    private var totalAmount: Double = 0
    
    private lazy var cartTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [fontWeightAxis : 650])
        label.text = "Cart"
        return label
    }()
    
    private lazy var cartIsEmptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = ColorManager.shared.label
        label.text = "Cart Is Empty"
        label.font = UIFont(name: "Raleway", size: 22)
        label.numberOfLines = 1
        label.layer.shadowOffset = CGSize(width: 3, height: 3)
        label.layer.shadowOpacity = 0.2
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2
        label.isHidden = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = ColorManager.shared.background
        table.separatorStyle = .none
        table.allowsSelection = false
        table.register(CartCell.self, forCellReuseIdentifier: CartCell.id)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private let spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Promo code block props.
    
    private let promoCodeViewHeight: CGFloat = 68
    private let promoCodeViewPadding: CGFloat = 10
    
    private lazy var promoCodeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.cart_promoCodeViewColor
        view.layer.cornerRadius = promoCodeViewHeight / 2
        return view
    }()
    
    private lazy var promoCodeTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Promo Code"
        field.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [fontWeightAxis : 600])
        field.textColor = ColorManager.shared.label
        field.tintColor = ColorManager.shared.orange
        return field
    }()
    
    private lazy var applyCodeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = (promoCodeViewHeight - promoCodeViewPadding*2) / 2
        button.backgroundColor = ColorManager.shared.cart_applyCodeButtonColor
        button.setTitle("Apply Code", for: .normal)
        button.setTitleColor(ColorManager.shared.background, for: .normal)
        button.setTitleColor(ColorManager.shared.background.withAlphaComponent(0.7), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [fontWeightAxis : 550])
        button.addTarget(self, action: #selector(applyCodeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Bill details block props.
    
    private lazy var billDetailsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.cart_billDetailsViewColor
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var billDetailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [fontWeightAxis : 750])
        label.text = "Bill Details"
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [fontWeightAxis : 500])
        label.text = "Product Price"
        return label
    }()
    
    private lazy var productPrice_amountOfMoneyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 16)
        label.text = "$0.00"
        return label
    }()
    
    private lazy var deliveryChargeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [fontWeightAxis : 500])
        label.text = "Delivery Charge"
        return label
    }()
    
    private lazy var deliveryCharge_amountOfMoneyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 16)
        label.text = "$\(String(format: "%.2f", deliveryPrice))"
        return label
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.labelGray.withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [fontWeightAxis : 700])
        label.text = "Total Amount"
        return label
    }()
    
    private lazy var totalAmount_amountOfMoneyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "$0.00"
        return label
    }()
    
    private lazy var continueOrderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 26
        button.backgroundColor = ColorManager.shared.cart_continueOrderButtonColor
        button.setTitle("Continue Order", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [fontWeightAxis : 550])
        button.addTarget(self, action: #selector(continueOrderButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        checkCart()
    }
    
    // MARK: - Private methods
    
    private func checkCart() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataNotification(_:)), name: NSNotification.Name("DataNotification"), object: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        view.addSubview(cartTitle)
        view.addSubview(cartIsEmptyLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(tableView)
        scrollView.addSubview(promoCodeView)
        scrollView.addSubview(billDetailsView)
        scrollView.addSubview(spacerView)
        
        promoCodeView.addSubview(promoCodeTextField)
        promoCodeView.addSubview(applyCodeButton)
        billDetailsView.addSubview(billDetailsLabel)
        billDetailsView.addSubview(productPriceLabel)
        billDetailsView.addSubview(productPrice_amountOfMoneyLabel)
        billDetailsView.addSubview(deliveryChargeLabel)
        billDetailsView.addSubview(deliveryCharge_amountOfMoneyLabel)
        billDetailsView.addSubview(divider)
        billDetailsView.addSubview(totalAmountLabel)
        billDetailsView.addSubview(totalAmount_amountOfMoneyLabel)
        billDetailsView.addSubview(continueOrderButton)
        
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            cartTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 4),
            cartTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cartIsEmptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cartIsEmptyLabel.topAnchor.constraint(equalTo: cartTitle.bottomAnchor, constant: 120),
            
            scrollView.topAnchor.constraint(equalTo: cartTitle.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tableView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            promoCodeView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 12),
            promoCodeView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            promoCodeView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            promoCodeView.heightAnchor.constraint(equalToConstant: promoCodeViewHeight),
            promoCodeView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            applyCodeButton.heightAnchor.constraint(equalToConstant: promoCodeViewHeight - promoCodeViewPadding*2),
            applyCodeButton.centerYAnchor.constraint(equalTo: promoCodeView.centerYAnchor),
            applyCodeButton.trailingAnchor.constraint(equalTo: promoCodeView.trailingAnchor, constant: -promoCodeViewPadding),
            applyCodeButton.widthAnchor.constraint(equalToConstant: 140),
            promoCodeTextField.centerYAnchor.constraint(equalTo: promoCodeView.centerYAnchor),
            promoCodeTextField.leadingAnchor.constraint(equalTo: promoCodeView.leadingAnchor, constant: 18),
            promoCodeTextField.trailingAnchor.constraint(equalTo: applyCodeButton.leadingAnchor, constant: -promoCodeViewPadding),
            
            billDetailsView.topAnchor.constraint(equalTo: promoCodeView.bottomAnchor, constant: 12),
            billDetailsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            billDetailsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            billDetailsView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            billDetailsLabel.topAnchor.constraint(equalTo: billDetailsView.topAnchor, constant: 32),
            billDetailsLabel.leadingAnchor.constraint(equalTo: billDetailsView.leadingAnchor, constant: 16),
            productPriceLabel.topAnchor.constraint(equalTo: billDetailsLabel.bottomAnchor, constant: 16),
            productPriceLabel.leadingAnchor.constraint(equalTo: billDetailsLabel.leadingAnchor),
            productPrice_amountOfMoneyLabel.centerYAnchor.constraint(equalTo: productPriceLabel.centerYAnchor),
            productPrice_amountOfMoneyLabel.trailingAnchor.constraint(equalTo: billDetailsView.trailingAnchor, constant: -12),
            deliveryChargeLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 16),
            deliveryChargeLabel.leadingAnchor.constraint(equalTo: billDetailsLabel.leadingAnchor),
            deliveryCharge_amountOfMoneyLabel.centerYAnchor.constraint(equalTo: deliveryChargeLabel.centerYAnchor),
            deliveryCharge_amountOfMoneyLabel.trailingAnchor.constraint(equalTo: productPrice_amountOfMoneyLabel.trailingAnchor),
            divider.topAnchor.constraint(equalTo: deliveryChargeLabel.bottomAnchor, constant: 13),
            divider.leadingAnchor.constraint(equalTo: billDetailsLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: productPrice_amountOfMoneyLabel.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            totalAmountLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            totalAmountLabel.leadingAnchor.constraint(equalTo: billDetailsLabel.leadingAnchor),
            totalAmount_amountOfMoneyLabel.centerYAnchor.constraint(equalTo: totalAmountLabel.centerYAnchor),
            totalAmount_amountOfMoneyLabel.trailingAnchor.constraint(equalTo: productPrice_amountOfMoneyLabel.trailingAnchor),
            continueOrderButton.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 32),
            continueOrderButton.leadingAnchor.constraint(equalTo: billDetailsView.leadingAnchor, constant: 16),
            continueOrderButton.trailingAnchor.constraint(equalTo: billDetailsView.trailingAnchor, constant: -16),
            continueOrderButton.heightAnchor.constraint(equalToConstant: 52),
            continueOrderButton.bottomAnchor.constraint(equalTo: billDetailsView.bottomAnchor, constant: -18),
            
            spacerView.topAnchor.constraint(equalTo: billDetailsView.bottomAnchor),
            spacerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            spacerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            spacerView.heightAnchor.constraint(equalToConstant: 92),
            spacerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
    }
    
    private func updateTableViewHeight() {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        let cellHeight: CGFloat = 110
        tableViewHeightConstraint?.constant = CGFloat(numberOfRows) * cellHeight
    }
    
    private func calculateTheBill() {
        var amount: Double = 0
        for item in cartContent {
            amount += Double(item.quantity) * item.dish.price
        }
        totalAmount = amount + deliveryPrice
        productPrice_amountOfMoneyLabel.text = "$\(String(format: "%.2f", amount))"
        totalAmount_amountOfMoneyLabel.text = "$\(String(format: "%.2f", totalAmount))"
    }
    
    // MARK: - ObjC methods
    
    @objc
    private func applyCodeButtonTapped() {
        print(#function)
    }
    
    @objc
    private func continueOrderButtonTapped() {
        let paymentPage = PaymentVC()
        paymentPage.modalTransitionStyle = .coverVertical
        paymentPage.modalPresentationStyle = .overFullScreen
        present(paymentPage, animated: true)
    }
    
    @objc 
    private func handleDataNotification(_ notification: Notification) {
        if let data = notification.userInfo?["data"] as? [CartItem] {
            cartIsEmptyLabel.isHidden = true
            scrollView.isHidden = false
            cartContent = data
        }
    }
}

// MARK: - TableView delegate methods

extension CartTabVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.id, for: indexPath) as! CartCell
        cell.cartItemID = cartContent[indexPath.row].id
        cell.cartItem = cartContent[indexPath.row]
        cell.cartItemImageBackColor = cartContent[indexPath.row].productImageBackColor
        cell.itemQuantityHandler = { [weak self] id, quantity in
            self?.cartContent[id].quantity = quantity
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
}
