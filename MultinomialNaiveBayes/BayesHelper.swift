//
//  BayesHelper.swift
//  MultinomialNaiveBayes
//
//  Created by Sridhar, Swaroop (US - Bengaluru) on 22/05/17.
//  Copyright © 2017 Sridhar, Swaroop (US - Bengaluru). All rights reserved.
//

import UIKit

public typealias ClassifierTestFormat = (class: String, trainigData: String)
public typealias Classifier = (class: String, weight: Double)

class BayesHelper: NSObject {
    public var corpusWords:Dictionary <String,Int> = Dictionary()
    public var classWords:Dictionary<String,Array<String>> = Dictionary()
    public var trainingDataArray:Array = Array<ClassifierTestFormat>()
    public var classes:Array<String> = Array()

    override init() {
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
        
        //Getting all training data classes
        for data in self.trainingDataArray {
            self.classes.append(data.class)
        }
        
        //Removing Duplicates
        let classSet = Set<String>(self.classes)
        self.classes = Array(classSet)        
    }
    
    func prepareDataForWeights() {
            for data in self.trainingDataArray {
                let stmt:NSString = data.trainigData as NSString
                let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
                let stringRange = NSMakeRange(0, stmt.length)
                let languageMap = ["Latn":["en"]]
                let orthography = NSOrthography(dominantScript: "Latn", languageMap: languageMap)
                
                stmt.enumerateLinguisticTags(
                    in: stringRange,
                    scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass,
                    options: options,
                    orthography: orthography)
                { (tag, tokenRange, sentenceRange, _) -> () in
                    let currentEntity = stmt.substring(with: tokenRange)
                    //print(">\(currentEntity):\(tag)")
                    
                    if self.corpusWords[currentEntity] == nil {
                        if currentEntity.contains("'s") {
                            //Ignore 's
                        } else {
                            self.corpusWords[currentEntity]  = 1
                        }
                    } else {
                        var count:Int = self.corpusWords[currentEntity]!
                        count = count + 1
                        self.corpusWords[currentEntity]  = count
                    }
                }
                
                stmt.enumerateLinguisticTags(
                    in: stringRange,
                    scheme: NSLinguisticTagSchemeLemma,
                    options: options,
                    orthography: orthography)
                { (tag, tokenRange, sentenceRange, _) -> () in
                    let currentEntity = stmt.substring(with: tokenRange)
                    //print(">\(currentEntity):\(tag)")
                    
                    if (self.classWords[data.class] == nil) {
                        if currentEntity.contains("'s") {
                            //Ignore 's
                        } else {
                            self.classWords[data.class] = [tag]
                        }
                            
                    } else {
                        if currentEntity.contains("'s") || currentEntity.contains("") {
                            //Ignore 's
                        } else {
                            if var elements = self.classWords[data.class] {
                                elements.append(tag)
                                self.classWords[data.class] = elements
                            }
                        }
                    }
                }
            }
        //print(self.corpusWords)
        //.print("--------------------------\n")
        //print(self.classWords)
    }

    func calculateClassScore(sentence:String, classname: String)->Double {
        let stmt:NSString = sentence as NSString
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
        let stringRange = NSMakeRange(0, stmt.length)
        let languageMap = ["Latn":["en"]]
        let orthography = NSOrthography(dominantScript: "Latn", languageMap: languageMap)
        
        var score = Double()
        
        stmt.enumerateLinguisticTags(
            in: stringRange,
            scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass,
            options: options,
            orthography: orthography)
        { (tag, tokenRange, sentenceRange, _) -> () in
            let currentEntity = stmt.substring(with: tokenRange)
            //print(">\(currentEntity):\(tag)")
            
            for classValues in self.classWords[classname]! {
                if classValues == currentEntity {
                    if let entity = self.corpusWords[currentEntity] {
                        score +=  1 / Double(entity)
                    }
                }
            }
        }
        return score
    }
    
    func classify(sentence:String)->Classifier {
        // now we can find the class with the highest score
        var highClass = String()
        var highScore = Double()
        for classValue in  self.classes {
            let score = self.calculateClassScore(sentence: sentence,classname: classValue)
            if score > highScore {
                highScore = Double(round(score))
                highClass = classValue
            }
        }
        return (highClass,highScore)
    }
    
    
}
