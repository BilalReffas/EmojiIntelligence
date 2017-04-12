import UIKit
import AudioToolbox

public class NeuralNetworkViewController: UIViewController {
    
    /// The current section
    fileprivate var currentSection: Section = .teach {
        didSet {
            if currentSection == .play {
                self.emojiLabel.fadeOut(withDuration: 0.3)
                self.teachButton.fadeOut(withDuration: 0.3)
                self.playSectionButton.setTitleColor(UIColor(red: 235.0 / 255.0, green: 28.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0), for: .normal)
                self.teachSectionButton.setTitleColor(UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0), for: .normal)
                self.explainLabel.text = "DRAW YOUR SHAPE"
                self.drawView.clear()
            } else {
                self.playSectionButton.setTitleColor(UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0), for: .normal)
                self.teachSectionButton.setTitleColor(UIColor(red: 235.0 / 255.0, green: 28.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0), for: .normal)
                self.emojiLabel.fadeIn(withDuration: 0.3)
                self.teachButton.fadeIn(withDuration: 0.3)
                self.explainLabel.text = emojis[index].drawText
                self.drawView.clear()
            }
        }
        
    }
    
    /// The index to update the UI
    fileprivate var index: Int = 0  {
        didSet {
            emojiLabel.text = emojis[index].emoji
            explainLabel.text = emojis[index].drawText
            teachButton.setTitle(emojis[index].buttonText, for: .normal)
        }
    }
    
    /// The Play Section Button
    fileprivate lazy var emojiAnimationLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = true
        label.text = "🙂"
        label.font = UIFont.systemFont(ofSize: 70.0)
        
        return label
        
    }()
    
    /// The Image Processor
    fileprivate lazy var imgProcessor: ImageProcessor = {
       let imgProcessor = ImageProcessor()
        
        return imgProcessor
    }()
    
    
    /// The ProgressView for the Learning
    fileprivate lazy var progressView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        view.backgroundColor = UIColor(red: 235.0 / 255.0, green: 28.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    /// The Status Label
    fileprivate lazy var statusLabel: UILabel = {
       let label = UILabel()
        label.text = "🤖 TEACH ME..."
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    /// The Play Section Button
    fileprivate lazy var playSectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("PLAY", for: .normal)
        button.setTitleColor(UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18.0)
        button.addTarget(self, action: #selector(NeuralNetworkViewController.playSectionPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center

        return button
    }()
    
    /// The Teach Section Button
    fileprivate lazy var teachSectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("TEACH", for: .normal)
        button.setTitleColor(UIColor(red: 235.0 / 255.0, green: 28.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18.0)
        button.addTarget(self, action: #selector(NeuralNetworkViewController.teachSectionPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        
        return button
    }()
    
    /// The Teach Button
    fileprivate lazy var teachButton: UIButton = {
        let button = UIButton()
        button.setTitle("TEACH HAPPY", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundColor(color: UIColor(red: 235.0 / 255.0, green: 28.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0), forState: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        button.addTarget(self, action: #selector(NeuralNetworkViewController.teachPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        
        return button
    }()
    
    /// The Explain Label
    fileprivate lazy var explainLabel: UILabel = {
        let label = UILabel()
        label.text = "DRAW A SMILE"
        label.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
        
    }()
    
    /// The Play Section Button
    fileprivate lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "🙂"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 70.0)
        
        return label
        
    }()
    
    /// The Draw View
    fileprivate lazy var drawView: DrawView = {
        let view = DrawView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        
        return view
    }()
    
    /// The Emoji Data Set which will be trained
    fileprivate var emojis: [NNEmoji] = {
        return [NNEmoji(emoji: "🙂", drawText: "DRAW A SMILE", buttonText: "TEACH HAPPY"),
                NNEmoji(emoji: "😮", drawText: "DRAW A CIRCLE", buttonText: "TEACH DAMN"),
                NNEmoji(emoji: "😍", drawText: "DRAW A HEART", buttonText: "TEACH LOVE"),
                NNEmoji(emoji: "😴", drawText: "DRAW A ZED", buttonText: "TEACH SLEEPY"),
                NNEmoji(emoji: "😐", drawText: "DRAW A LINE", buttonText: "TEACH POKER FACE"),
                NNEmoji(emoji: "☹️", drawText: "DRAW A FROWN", buttonText: "TEACH SAD")]
    }()
    
    /// The Neural Network 🚀
    fileprivate lazy var neuralNetwork: NeuralNetwork = {
        let neuralNetWork = NeuralNetwork(inputSize: 64, hiddenSize: 15, outputSize: 6)
        
        return neuralNetWork
    }()
    
    // The Network is Ready to predict
    fileprivate var isReady: Bool = false
    
    // The Training Data for the input neuron
    fileprivate var traningData: [[Float]] = [] {
        didSet {
            if traningData.count == 12 { statusLabel.textColor = UIColor.white }
            if traningData.count == 18 {
                currentSection = .play
                statusLabel.text = "🤖 LEARNING AND THINKING 💭"
                statusLabel.startBlink()
                learnNetwork()
            }
            progressView.frame = CGRect(x: 0, y: 0, width: Double(self.view.frame.width) /  (Double(18) / Double(traningData.count)), height: 30)
        }
    }
    
    /// The Result Data labels for the output
    fileprivate var traningResults: [[Float]] = []
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupConstraints()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension NeuralNetworkViewController {
    
    func setupConstraints() {
        self.view.addSubview(drawView)
        self.drawView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        self.drawView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        self.view.addSubview(explainLabel)
        self.explainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.explainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.view.addSubview(teachButton)
        self.teachButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 1.0).isActive = true
        self.teachButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.teachButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        self.teachButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5.0).isActive = true
        self.view.addSubview(emojiLabel)
        self.emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.emojiLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 65.0).isActive = true
        self.view.addSubview(teachSectionButton)
        self.teachSectionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45.0).isActive = true
        self.teachSectionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        self.view.addSubview(playSectionButton)
        self.playSectionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45.0).isActive = true
        self.playSectionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
        self.view.addSubview(emojiAnimationLabel)
        self.view.addSubview(progressView)
        self.view.addSubview(statusLabel)
        self.statusLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.statusLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        self.statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}

extension NeuralNetworkViewController {
    
    func addNeuronData(input: [Float]) {
        var traningResults: [[Float]] = [
            [1,0,0,0,0,0], // 🙂
            [0,1,0,0,0,0], // 😮
            [0,0,1,0,0,0], // 😍
            [0,0,0,1,0,0], // 😴
            [0,0,0,0,1,0], // 😐
            [0,0,0,0,0,1]  // ☹️
        ]
        
        self.traningResults.append(traningResults[index])
        self.traningData.append(input)
        self.drawView.clear()
        
    }
    
    func learnNetwork() {
        DispatchQueue.global(qos: DispatchQoS.userInteractive.qosClass).async {
            for iterations in 0..<NeuralNetwork.iterations {
                
                for i in 0..<self.traningResults.count {
                    self.neuralNetwork.train(input: self.traningData[i], targetOutput: self.traningResults[i], learningRate: NeuralNetwork.learningRate, momentum: NeuralNetwork.momentum)
                }
                
                for i in 0..<self.traningResults.count {
                    let data = self.traningData[i]
                    let _ = self.neuralNetwork.run(input: data)
                }
                
                print("Iterations: \(iterations)")
            }
            
            self.isReady = true
            
            DispatchQueue.main.async {
                self.statusLabel.stopBlink()
                self.statusLabel.text = "🚀 Start drawing..."
            }
            
        }
    
    }

    func predict(inputData: [Float]) {
        
        guard let img = self.drawView.getImage() else {
            return
        }

        let x = imgProcessor.centerOf(image: img).midX
        let y = imgProcessor.centerOf(image: img).midY

        let prediction = self.neuralNetwork.run(input: inputData).filter { $0 >= 0.8 }
        self.emojiAnimationLabel.isHidden = false
        self.emojiAnimationLabel.center = CGPoint(x: x, y: y)

        if prediction.count == 0 {
            self.emojiAnimationLabel.transformAnimation()
            self.emojiAnimationLabel.text = "🤔"
            SystemSoundID.playFileNamed(fileName: "wrong", withExtenstion: "wav")
        } else {
            self.neuralNetwork.run(input: inputData).enumerated().forEach { index, element in
                if element >= 0.8 {
                    self.emojiAnimationLabel.transformAnimation()
                    self.emojiAnimationLabel.text = self.emojis[index].emoji
                    SystemSoundID.playFileNamed(fileName: "correct", withExtenstion: "wav")
                }
             }
        }
        
        self.drawView.clear()
    }
}

extension NeuralNetworkViewController {
    
    func teachSectionPressed(_ button: UIButton) {
        self.emojiAnimationLabel.isHidden = true
        self.currentSection = .teach
    }
    
    func playSectionPressed(_ button: UIButton) {
        self.currentSection = .play
    }
    
    func teachPressed(_ button: UIButton) {
        self.teachButton.isHidden = true
        self.explainLabel.isHidden = false
        self.addNeuronData(input: self.returnImageBlock())
        index = index == 5 ? 0 : index+1
    }
    
    
}

extension NeuralNetworkViewController: DrawViewDelegate {
    
    public func drawViewMoved(view: DrawView) {
        self.teachButton.isHidden = false
        self.explainLabel.isHidden = true
    }
    
    public func drawViewDidFinishDrawing(view: DrawView) {
        if self.currentSection == .play && self.isReady {
            predict(inputData: self.returnImageBlock())
        }
    }
    
    func returnImageBlock() -> [Float] {
        guard let image = self.drawView.getImage(),
            let mnistImage = self.imgProcessor.resize(image: image) else {
                return []
        }
        
        print(self.imgProcessor.imageBlock(image: mnistImage))
        return self.imgProcessor.imageBlock(image: mnistImage)
    }
}
