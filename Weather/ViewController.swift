import UIKit

class WeatherViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let weatherTypes = ["Солнце", "Дождь", "Гроза", "Снег", "Облачно"]
    let weatherIcons = ["sun", "rain", "storm", "snow", "cloud"]
    var collectionView: UICollectionView!
    let backgroundImageView = UIImageView()
    var cloudImageView: UIImageView!
    let backgroundColors: [UIColor] = [
        UIColor(red: 0xB7/255, green: 0xEE/255, blue: 0xFF/255, alpha: 1.0), // B7EEFF
        UIColor(red: 0xCF/255, green: 0xDD/255, blue: 0xFF/255, alpha: 1.0), // CFDDFF
        UIColor(red: 0xC5/255, green: 0xC5/255, blue: 0xC5/255, alpha: 1.0), // C5C5C5
        UIColor(red: 0x51/255, green: 0x6E/255, blue: 0x9A/255, alpha: 1.0), // 516E9A
        UIColor(red: 0x96/255, green: 0x96/255, blue: 0x96/255, alpha: 1.0)  // 969696
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupBackgroundImageView()
        setupTitleLabel()
        setupCollectionView()
        setupCloudImageView()
        
        // Выбор случайного погодного явления при запуске
        let randomIndex = Int.random(in: 0..<weatherTypes.count)
        selectWeather(at: randomIndex)
    }
    
    func setupBackgroundImageView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = "Weather"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 20
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: "weatherCell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    func setupCloudImageView() {
        cloudImageView = UIImageView()
        view.addSubview(cloudImageView)
        
        cloudImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cloudImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            cloudImageView.widthAnchor.constraint(equalToConstant: 300),
            cloudImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    func startCloudAnimation(imageName: String) {
        cloudImageView.image = UIImage(named: imageName)
        cloudImageView.alpha = 1

        cloudImageView.frame.origin.x = -cloudImageView.frame.width

        let screenWidth = view.frame.width
        let cloudWidth = cloudImageView.frame.width
        let distance = screenWidth + cloudWidth

        UIView.animate(withDuration: 10.0, delay: 0, options: [.curveLinear], animations: {
            self.cloudImageView.frame.origin.x += distance
        }) { _ in
            UIView.animate(withDuration: 2.0, animations: {
                self.cloudImageView.alpha = 0
            }, completion: { _ in
                self.cloudImageView.alpha = 1
                self.cloudImageView.frame.origin.x = -self.cloudImageView.frame.width
            })
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCell
        cell.configure(with: weatherIcons[indexPath.row])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectWeather(at: indexPath.row)
    }
    
    // MARK: - Helper Methods
    
    func selectWeather(at index: Int) {
        print("Selected weather: \(weatherTypes[index])")
        animateBackground(for: index)
        startCloudAnimation(imageName: "\(weatherIcons[index])_anim")
    }

    func animateBackground(for index: Int) {
        let selectedColor = backgroundColors[index]
        
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = selectedColor
        }
    }
}
