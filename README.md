# SwiftOfflineNLPMultinomialNaiveBayes
This is a naive classifier, this just determines the words separately and add weights from the occurrences from each sentence of the training data fed. From the weightage calculated, it determines the high weighted classifier and throws it.

For the example, I have used 

        trainingDataArray.append(ClassifierTestFormat("greeting","how are you?"))
        trainingDataArray.append(ClassifierTestFormat("greeting","how is your day?"))
        trainingDataArray.append(ClassifierTestFormat("greeting","good day"))
        trainingDataArray.append(ClassifierTestFormat("greeting","how is it going today?"))
        
        trainingDataArray.append(ClassifierTestFormat("goodbye","have a nice day"))
        trainingDataArray.append(ClassifierTestFormat("goodbye","see you later"))
        trainingDataArray.append(ClassifierTestFormat("goodbye","have a nice day"))
        trainingDataArray.append(ClassifierTestFormat("goodbye","talk to you soon"))
        
        trainingDataArray.append(ClassifierTestFormat("sandwich","make me a sandwich"))
        trainingDataArray.append(ClassifierTestFormat("sandwich","can you make a sandwich?"))
        trainingDataArray.append(ClassifierTestFormat("sandwich","having a sandwich today?"))
        trainingDataArray.append(ClassifierTestFormat("sandwich","what's for lunch?"))
        
The idea of getting this developed in swift was from a python naive algorithm that was available in https://chatbotslife.com/text-classification-using-algorithms-e4d50dcba45

