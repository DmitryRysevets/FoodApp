//
//  TabBarVC.swift
//  FoodApp
//

import UIKit

final class CartTabVC: UIViewController {
    
    lazy var cartContent: [CartItem] = [] {
        didSet {
            calculateTheBill()
            
            if cartItemColors.count != cartContent.count {
                cartItemColors = ColorManager.shared.getColors(cartContent.count)
            }
            
            if cartContent.isEmpty {
                emptyCartView.isHidden = false
                scrollView.isHidden = true
            } else {
                emptyCartView.isHidden = true
                scrollView.isHidden = false
            }
        }
    }
    
    private var cartItemColors: [UIColor] = []
    
    private var tableViewHeightConstraint: NSLayoutConstraint?

    private var productPrice: Double = 0
    private var deliveryPrice: Double = 2.0
    private var totalAmount: Double = 0
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cartTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [Constants.fontWeightAxis : 650])
        label.text = "Cart"
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
        table.isScrollEnabled = false
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
        field.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 600])
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
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(applyCodeButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(applyCodeButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
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
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 750])
        label.text = "Bill Details"
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 500])
        label.text = "Product Price"
        return label
    }()
    
    private lazy var productPrice_amountOfMoneyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var deliveryChargeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 500])
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
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 700])
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
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(continueOrderButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(continueOrderButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return button
    }()
    
    // MARK: - Empty cart view props.
    
    private lazy var emptyCartView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        return view
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
        return label
    }()
    
    private lazy var emptyCartImageView: UIImageView = {
        let image = UIImage(named: "EmptyCart")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CoreDataManager.shared.saveCart(cartContent)
    }
    
    // MARK: - Private methods
    
    private func checkCart() {
        let items = CoreDataManager.shared.fetchCart()
        if cartContent != items {
            cartContent = items
            tableView.reloadData()
            updateTableViewHeight()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        view.addSubview(headerView)
        view.addSubview(emptyCartView)
        view.addSubview(scrollView)
        
        headerView.addSubview(cartTitle)
        
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
        
        emptyCartView.addSubview(cartIsEmptyLabel)
        emptyCartView.addSubview(emptyCartImageView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constants.headerHeight),
            cartTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -4),
            cartTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tableView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            promoCodeView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 40),
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
            spacerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            emptyCartView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            emptyCartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyCartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyCartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            cartIsEmptyLabel.centerXAnchor.constraint(equalTo: emptyCartView.centerXAnchor),
            cartIsEmptyLabel.topAnchor.constraint(equalTo: emptyCartView.topAnchor, constant: 100),
            emptyCartImageView.topAnchor.constraint(equalTo: cartIsEmptyLabel.bottomAnchor, constant: 32),
            emptyCartImageView.centerXAnchor.constraint(equalTo: emptyCartView.centerXAnchor),
            emptyCartImageView.heightAnchor.constraint(equalToConstant: 285),
            emptyCartImageView.widthAnchor.constraint(equalToConstant: 255)
            
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
    
    private func deleteCartItem(at indexPath: IndexPath) {
        let itemToDelete = cartContent[indexPath.row]
        CoreDataManager.shared.deleteCartItem(by: itemToDelete.dish.id)

        cartItemColors.remove(at: indexPath.row)
        cartContent.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        UIView.animate(withDuration: 0.3) {
            self.updateTableViewHeight()
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - ObjC methods

    @objc
    private func applyCodeButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.applyCodeButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func applyCodeButtonTouchUp() {
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {
            self.applyCodeButton.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @objc
    private func continueOrderButtonTouchDown() {
        UIView.animate(withDuration: 0.05) {
            self.continueOrderButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func continueOrderButtonTouchUp() {
        let paymentPage = PaymentVC(amountDue: totalAmount)
        paymentPage.modalTransitionStyle = .coverVertical
        paymentPage.modalPresentationStyle = .overFullScreen
        present(paymentPage, animated: true)
        
        UIView.animate(withDuration: 0.05, delay: 0.05, options: [], animations: {
            self.continueOrderButton.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

// MARK: - TableView delegate methods

extension CartTabVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.id, for: indexPath) as! CartCell
        cell.cartItemID = indexPath.row
        cell.cartItem = cartContent[indexPath.row]
        cell.cartItemImageBackColor = cartItemColors[indexPath.row]
        cell.itemQuantityHandler = { [weak self] id, quantity in
            self?.cartContent[id].quantity = quantity
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            self?.deleteCartItem(at: indexPath)
            completionHandler(true)
        }
        
        if let trashImage = UIImage(systemName: "trash") {
            let size = CGSize(width: 26, height: 30)
            let renderer = UIGraphicsImageRenderer(size: size)
            let tintedImage = renderer.image { context in
                trashImage.withTintColor(UIColor(red: 0.92, green: 0.23, blue: 0.35, alpha: 1.00)).draw(in: CGRect(origin: .zero, size: size))
            }
            deleteAction.image = tintedImage
        }
        
        deleteAction.backgroundColor = ColorManager.shared.background

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
