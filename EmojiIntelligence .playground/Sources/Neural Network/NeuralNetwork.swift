import Foundation

public class NeuralNetwork {
    
    public static var learningRate: Float = 0.3
    public static var momentum: Float = 0.6
    public static var iterations: Int = 70000
    
    private var layers: [Layer] = []
    
    public init(inputSize: Int, hiddenSize: Int, outputSize: Int) {
        self.layers.append(Layer(inputSize: inputSize, outputSize: hiddenSize))
        self.layers.append(Layer(inputSize: hiddenSize, outputSize: outputSize))
    }
    
    public func run(input: [Float]) -> [Float] {
        
        var activations = input
        
        for i in 0..<layers.count {
            activations = layers[i].run(inputArray: activations)
        }
        
        return activations
    }
    
    public func train(input: [Float], targetOutput: [Float], learningRate: Float, momentum: Float) {
        
        let calculatedOutput = run(input: input)
        
        var error = zip(targetOutput, calculatedOutput).map { $0 - $1 }
        
        for i in (0...layers.count-1).reversed() {
            error = layers[i].train(error: error, learningRate: learningRate, momentum: momentum)
        }
        
    }
    
}
