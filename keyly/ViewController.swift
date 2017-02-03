import UIKit
import AVFoundation

class PianoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let numberOfOctaves = 6
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var octaveSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if let flow = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.itemSize = CGSize(width: 560, height: UIScreen.main.bounds.height)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let flow = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.itemSize = CGSize(width: 560, height: UIScreen.main.bounds.height)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfOctaves
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OctaveCollectionViewCell", for: indexPath) as? OctaveCollectionViewCell  else {
            return UICollectionViewCell()
        }
        
        cell.octave = indexPath.row
        return cell
    }
    
    @IBAction func octaveChanged(_ sender: UISlider) {
        let offsetX = (CGFloat(sender.value) / 100) * self.collectionView.contentSize.width
        
        self.collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
}

class OctaveCollectionViewCell : UICollectionViewCell {
    var audioPlayer = AVAudioPlayer()
    var octave: Int = 0
    @IBOutlet weak var CKey: UIButton!
    @IBOutlet var whiteKeys: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for key in whiteKeys {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: 1, height: UIScreen.main.bounds.height)
            layer.backgroundColor = UIColor.black.cgColor
            key.layer.addSublayer(layer)
        }
    }
    
    @IBAction func keyTouched(_ sender: UIButton) {
        let soundNumber:Int = octave * 12 + sender.tag
        guard let path = Bundle.main.path(forResource: "piano-ff-\(soundNumber)", ofType: "wav")  else { return }
        let sound = URL(fileURLWithPath: path)
        do {
             self.audioPlayer = try AVAudioPlayer(contentsOf: sound)
        } catch { }

        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
        
    }
}


