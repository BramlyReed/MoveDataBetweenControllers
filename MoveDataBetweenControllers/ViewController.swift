import UIKit

class ViewController: UIViewController {
  private var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.spacing = 10
    return stackView
  }()
  private var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isScrollEnabled = false
    view.showsVerticalScrollIndicator = false
    return view
  }()
  private var buttonDelegate: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Delegate", for: .normal)
    button.backgroundColor = .lightGray
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(openDelegate), for: .touchUpInside)
    return button
  }()
  private var buttonNotification: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("NotifCenter", for: .normal)
    button.backgroundColor = .orange
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(openNotif), for: .touchUpInside)
    return button
  }()
  private var buttonCallBack: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("CallBack", for: .normal)
    button.backgroundColor = .yellow
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(openCallBack), for: .touchUpInside)
    return button
  }()
  private var labelWithExplonation: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  private var cons: NSLayoutDimension?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Стартовый экран"
    view.backgroundColor = .white
    prepareView()
    NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: Notification.Name(rawValue: "Notif"), object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(Notification.Name("Notif"))
  }
  
  private func prepareView() {
    setStackView()
    setScrollView()
    setLabel()
  }
  
  private func setScrollView() {
    view.addSubview(scrollView)
    NSLayoutConstraint.activate(
      [
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
        scrollView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -5),
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      ]
    )
  }
  
  private func setLabel() {
    scrollView.addSubview(labelWithExplonation)
    NSLayoutConstraint.activate(
      [
        labelWithExplonation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
        labelWithExplonation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        labelWithExplonation.topAnchor.constraint(equalTo: scrollView.topAnchor),
        labelWithExplonation.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
      ]
    )
  }
  
  private func setStackView() {
    view.addSubview(stackView)
    NSLayoutConstraint.activate(
      [
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
      ]
    )
    stackView.addArrangedSubview(buttonDelegate)
    stackView.addArrangedSubview(buttonNotification)
    stackView.addArrangedSubview(buttonCallBack)
  }
  
  @objc private func openDelegate() {
    let vc = SecondViewController(type: .delegateType)
    vc.delegate = self
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc private func openNotif() {
    let vc = SecondViewController(type: .notifType)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc private func openCallBack() {
    let vc = SecondViewController(type: .callBackType)
    navigationController?.pushViewController(vc, animated: true)
    vc.callBack = { [weak self] text in
      self?.updateText(text: text)
    }
  }
  
  private func updateText(text: String) {
    DispatchQueue.main.async {
      self.labelWithExplonation.text = text
      self.scrollView.isScrollEnabled = true
    }
  }
  
  @objc private func onNotification(notification: Notification) {
    guard let text = notification.object as? String else {
      return
    }
    updateText(text: text)
  }
}

extension ViewController: SecondControllerDelegate {
  func showText(text: String) {
    updateText(text: text)
  }
}
