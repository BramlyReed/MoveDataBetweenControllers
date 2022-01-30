import UIKit

protocol SecondControllerDelegate: AnyObject {
  func showText(text: String)
}

enum Types: String {
  case delegateType = "Делегат"
  case notifType = "Уведомления"
  case callBackType = "Кол Бэк"
  
  var explanation: String {
    switch self {
    case .delegateType:
      return "Делегирование - это шаблон проектирования, суть которого заключается в том чтобы передавать некоторые из свойств одного класса другому. В свифте это реализуется с помощью протоколов. Создается протокол, внутри которого записывают функцию, которая должна быть в классе, соответствующему протоколу. Класс, заинтересованный в получении изменных свойств, подписываются под изменения класса, в котором и будут происходить изменения. Также необязательно что-либо передавать по делегатам, можно через них просто сообщать что произошло какое-либо событие."
    case .notifType:
      return "Также можно передавать данные между контроллерами через Notification Center, который принимает уведомления и отправляет их под определенным именем. Это реализация щаблона проектирования - наблюдатель. Суть которого заключается в том, что наблюдатель подписывается на изменения объекта, моментально получая сигналы/данные с изменениями. В Notification Center это достигается за счет того, что у каждого наблюдаемого уведомления есть уникальное имя. Поэтому когда что либо происходит - то отправляется уведомление, все кто слушает его. Использование данного инструмента имеет смысл если 1) необходимо обновлять данные при определенном сценарии на нескольких контроллерах одновременно; 2) контроллеры между которыми будут передаваться данные не тесно связаны. Если не требуется регулярно отправлять данные во многих направлениях (например результат ответа с апи, от которого зависят несколько контроллеров), то лучше использовать делегат или колбэк. При этом если наблюдатель через какое-то время перестает быть нужным, то лучше его удалить."
    case .callBackType:
      return "У колбэка такая же конечная цель использования (что и у делегата), но применять его гораздо легче, тк это адаптированный вид делегата. Его можно определить локально, а задавать отдельную функцию или протокол - нет необходимости. Для его использования необходимо задать свойство для колбэка с типом значения в классе откуда отправляются изменения. И написать обработку полученного ответа в замыкании в классе который будет принимать. Однако во избежания цикла сильных ссылок, в замыкании необходимо указать слабую связь."
    }
  }
}

class SecondViewController: UIViewController {
  weak var delegate: SecondControllerDelegate?
  var callBack: ((String) -> Void)?
  private var nameofController: Types
  private var centerButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(someDeal), for: .touchUpInside)
    return button
  }()
  init(type: Types) {
    nameofController = type
    super.init(nibName: nil, bundle: nil)
    prepareView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    navigationItem.title = nameofController.rawValue
    view.backgroundColor = .white
  }
  
  private func prepareView() {
    view.addSubview(centerButton)
    centerButton.setTitle(nameofController.rawValue, for: .normal)
    NSLayoutConstraint.activate(
      [
        centerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        centerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        centerButton.widthAnchor.constraint(equalToConstant: 200),
        centerButton.heightAnchor.constraint(equalToConstant: 100)
      ]
    )
  }
  
  @objc private func someDeal() {
    switch nameofController {
    case .delegateType:
      delegate?.showText(text: nameofController.explanation)
    case .callBackType:
      callBack?(nameofController.explanation)
    case .notifType:
      NotificationCenter.default.post(name: Notification.Name(rawValue: "Notif"), object: nameofController.explanation)
    }
    navigationController?.popToRootViewController(animated: true)
  }
}
