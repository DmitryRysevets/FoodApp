//
//  PaymentMethodsVC.swift
//  FoodApp
//

import UIKit

final class PaymentMethodsVC: UIViewController {

    private var cards: [CardEntity] = [] {
        didSet {
            if cards.isEmpty {
                emptyPageView.isHidden = false
                tableView.isHidden = true
            } else {
                emptyPageView.isHidden = true
                tableView.isHidden = false
            }
        }
    }
    
    private var childInfoVC: PaymentCardInfoVC!
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = ColorManager.shared.background
        table.register(PaymentMethodsCell.self, forCellReuseIdentifier: PaymentMethodsCell.id)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    // MARK: - Header props.
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: configuration)?.resized(to: CGSize(width: 12, height: 16)).withTintColor(ColorManager.shared.label)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.backgroundColor = ColorManager.shared.headerElementsColor
        button.layer.cornerRadius = Constants.headerButtonSize / 2
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var paymentMethodsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [Constants.fontWeightAxis : 650])
        label.text = "Payment Methods"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = ColorManager.shared.label
        button.backgroundColor = ColorManager.shared.headerElementsColor
        button.layer.cornerRadius = Constants.headerButtonSize / 2
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView(frame: view.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    // MARK: - Empty page view props.
    
    private lazy var emptyPageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyPageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = ColorManager.shared.label
        label.text = "You have not added a payment method yet"
        label.font = UIFont(name: "Raleway", size: 22)
        label.numberOfLines = 2
        label.layer.shadowOffset = CGSize(width: 3, height: 3)
        label.layer.shadowOpacity = 0.2
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2
        return label
    }()
    
    private lazy var addNewCardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.regularButtonHeight / 2
        button.backgroundColor = ColorManager.shared.regularButtonColor
        button.setTitle("Add New Card", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(addNewAddressButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(addNewAddressButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cards = CoreDataManager.shared.fetchAllCards()
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(emptyPageView)
        view.addSubview(overlayView)
        
        headerView.addSubview(backButton)
        headerView.addSubview(paymentMethodsTitleLabel)
        headerView.addSubview(plusButton)

        emptyPageView.addSubview(emptyPageLabel)
        emptyPageView.addSubview(addNewCardButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPaymentCardInfoVC))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 52),
            backButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            plusButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            plusButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            plusButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor),
            paymentMethodsTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -4),
            paymentMethodsTitleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            paymentMethodsTitleLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyPageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyPageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyPageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            emptyPageView.heightAnchor.constraint(equalToConstant: 200),
            emptyPageLabel.centerXAnchor.constraint(equalTo: emptyPageView.centerXAnchor),
            emptyPageLabel.topAnchor.constraint(equalTo: emptyPageView.topAnchor, constant: 16),
            emptyPageLabel.leadingAnchor.constraint(equalTo: emptyPageView.leadingAnchor, constant: 16),
            emptyPageLabel.trailingAnchor.constraint(equalTo: emptyPageView.trailingAnchor, constant: -16),
            addNewCardButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
            addNewCardButton.leadingAnchor.constraint(equalTo: emptyPageView.leadingAnchor, constant: 40),
            addNewCardButton.trailingAnchor.constraint(equalTo: emptyPageView.trailingAnchor, constant: -40),
            addNewCardButton.bottomAnchor.constraint(equalTo: emptyPageView.bottomAnchor, constant: -16),
        ])
    }
    
    private func deleteCard(at indexPath: IndexPath) {
        guard let cardName = cards[indexPath.row].cardName else { return }
        CoreDataManager.shared.deleteCard(by: cardName)
        cards.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func setPrefferedInLocal(at indexPath: IndexPath) {
        for i in 0...cards.count-1 {
            cards[i].isPreferred = (i == indexPath.row)
        }
    }
    
    // MARK: - Objc methods
    
    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func plusButtonTapped() {
        let vc = AddNewCardVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc
    private func addNewAddressButtonTouchDown() {
        UIView.animate(withDuration: 0.05) {
            self.addNewCardButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func addNewAddressButtonTouchUp() {
        UIView.animate(withDuration: 0.05, delay: 0.05, options: [], animations: {
            self.addNewCardButton.transform = CGAffineTransform.identity
        }, completion: nil)
        plusButtonTapped()
    }
    
    @objc
    private func dismissPaymentCardInfoVC() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0
            self.childInfoVC.view.frame.origin.y = self.view.bounds.height
        }) { _ in
            self.overlayView.isHidden = true
            self.childInfoVC.willMove(toParent: nil)
            self.childInfoVC.view.removeFromSuperview()
            self.childInfoVC.removeFromParent()
        }
    }
    
    // MARK: - internal methods
    
    func presentPaymentCardInfoVC(at indexPath: IndexPath) {
        childInfoVC = PaymentCardInfoVC()
        childInfoVC.view.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height * 0.5)
        childInfoVC.cardData = cards[indexPath.row]
        childInfoVC.closePaymentCardInfoVCHandler = { [weak self] in
            self?.dismissPaymentCardInfoVC()
        }
        
        addChild(childInfoVC)
        view.addSubview(childInfoVC.view)
        childInfoVC.didMove(toParent: self)
        
        overlayView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 1
            self.childInfoVC.view.frame.origin.y = self.view.bounds.height - self.childInfoVC.view.frame.height
        })
    }

}

// MARK: - Table view methods

extension PaymentMethodsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodsCell.id, for: indexPath) as! PaymentMethodsCell
        
        cell.cardName = cards[indexPath.row].cardName
        cell.isPreferredPaymentMethod = cards[indexPath.row].isPreferred
        
        cell.goToCardInfoHandler = { [weak self] in
            self?.presentPaymentCardInfoVC(at: indexPath)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !cards[indexPath.row].isPreferred {
            guard let cardName = cards[indexPath.row].cardName else { return }
            CoreDataManager.shared.setPreferredCard(by: cardName)
            setPrefferedInLocal(at: indexPath)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            self?.deleteCard(at: indexPath)
            completionHandler(true)
        }
        
        if let trashImage = UIImage(systemName: "trash") {
            let size = CGSize(width: 26, height: 30)
            let renderer = UIGraphicsImageRenderer(size: size)
            let tintedImage = renderer.image { context in
                trashImage.withTintColor(ColorManager.shared.warningRed).draw(in: CGRect(origin: .zero, size: size))
            }
            deleteAction.image = tintedImage
        }
        
        deleteAction.backgroundColor = ColorManager.shared.background

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
