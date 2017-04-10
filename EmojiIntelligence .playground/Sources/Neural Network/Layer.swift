import Foundation


public extension ClosedRange where Bound: FloatingPoint {
    public func random() -> Bound {
        let range = self.upperBound - self.lowerBound
        let randomValue = (Bound(arc4random_uniform(UINT32_MAX)) / Bound(UINT32_MAX)) * range + self.lowerBound
        return randomValue
    }
}

public class Layer {
    
    private var output: [Float]
    private var input: [Float]
    private var weights: [Float]
    private var previousWeights: [Float]
    
    init(inputSize: Int, outputSize: Int) {
        self.output = [Float](repeating: 0, count: outputSize)
        self.input = [Float](repeating: 0, count: inputSize + 1)
        self.weights = (0..<(1 + inputSize) * outputSize).map { _ in
            return (-2.0...2.0).random()
        }
        previousWeights = [Float](repeating: 0, count: weights.count)
    }
    
    public func run(inputArray: [Float]) -> [Float] {
        
        for i in 0..<inputArray.count {
            input[i] = inputArray[i]
        }
        
        input[input.count-1] = 1
        var offSet = 0
        
        for i in 0..<output.count {
            for j in 0..<input.count {
                output[i] += weights[offSet+j] * input[j]
            }
            
            output[i] = ActivationFunction.sigmoid(x: output[i])
            offSet += input.count
            
        }
        
        return output
    }
    
    public func train(error: [Float], learningRate: Float, momentum: Float) -> [Float] {
        
        var offset = 0
        var nextError = [Float](repeating: 0, count: input.count)
        
        for i in 0..<output.count {
            
            let delta = error[i] * ActivationFunction.sigmoidDerivative(x: output[i])
            
            for j in 0..<input.count {
                let weightIndex = offset + j
                nextError[j] = nextError[j] + weights[weightIndex] * delta
                let dw = input[j] * delta * learningRate
                weights[weightIndex] += previousWeights[weightIndex] * momentum + dw
                previousWeights[weightIndex] = dw
            }
            
            offset += input.count
        }
        
        return nextError
    }
    
}
