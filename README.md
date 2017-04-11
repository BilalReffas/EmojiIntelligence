# EmojiIntelligence 

I created a neural network entirely in Swift. This is a demo to demonstrate what is possible to solve.
<br>
I used the Playground on macOS. 
<br>
I believe in open source I think to push humanity forward you have to open source all the things \o/

![](http://i.imgur.com/qhweGhT.gif)
<br>
<br>
You can watch the YouTube Video [here](https://www.youtube.com/watch?v=T9pplv7cZ7k)
<br>
<br>

## Abstract Overview

<img src="http://i.imgur.com/qVKMBym.png" width="350">

### This is how the encoded image look's like. 

![](http://imgur.com/3iRGrFv.png)

### Neural Network Story

I used this challenge to learn more about neural networks and machine learning.
A neural network consists of layers, and each layer has neurons. My network has three layers: an input layer, a hidden layer, and an output layer.
<br><br>
<img src="http://i.imgur.com/DZh33WL.png" width="250">
<br><br>
The input to my network has 64 binary numbers. These inputs are connected to the neurons in the hidden layer. The hidden layer performs some computation and passes the result to the output layer neuron out. This also performs a computation and then outputs a 0 or a 1. The input layer doesn’t actually do anything, they are just placeholders for the input value. Only the neurons in the hidden layer and the output layer perform computations.  The neurons from the input layer are connected to   the neurons in the hidden layer. Likewise, both neurons from the hidden layer are connected to the output layer. These kinds of layers are called fully-connected because every neuron is connected to every neuron in the next layer. Each connection between two neurons has a weight, which is just a number. These weights form the brain of my network. For the activation function in my network, I use the sigmoid function. ![](http://i.imgur.com/Xrhx1wl.png)<br><br>
Sigmoid is a mathematical function. The sigmoid takes in some number x and converts it into a value between 0 and 1. That is ideal for my purposes, since I am dealing with binary numbers.
This will turn a linear equation into something that is non-linear. This is important because without this, the network wouldn’t be able to learn any interesting things. 

I have already mentioned that the input to this network are 64 binary numbers. I resize the drawn image to 8x8 pixels which makes together 64 pixels. I go through the image and check each pixel if the pixel has a pink color I add a 1 to my array else I add a 0. At the end I will have 64 binary numbers which I can add to my input layer. 

My main goal was to make neural network and machine learning more accessible and fun. As well to learn more about the powerful features of playgrounds and neural networks. 

### Author

  [@reffas_bilal](https://twitter.com/Reffas_Bilal)
  
  [bilal@luubra.com]()
  

### Credits
  [Vincent Esche](https://twitter.com/regexident)
  
  [Per Harald Borgen](https://medium.com/learning-new-stuff/how-to-learn-neural-networks-758b78f2736e)
  
  [Matthijs Hollemans](http://machinethink.net/blog/the-hello-world-of-neural-networks/)

### Thank you 🎉

  If you like this project please leave a star 🌟 here on Github and share it.
  
### Luubra

  I'm working with [@leoMehlig ](https://twitter.com/leoMehlig) on Luubra. You will find more about it                    [here](https://www.luubra.com)
  <br>
  All pieces are handcrafted with a lot of love ❤️ and sent all around the world 🌍. 
  
### Known issues
  This projecty is currently only working on macOS. There is a bug on the iPad I already submitted the issue on the Bug Reporter. 
  I hope Apple will fix this soon.

### License

```
MIT License

Copyright (c) 2017 Luubra

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
