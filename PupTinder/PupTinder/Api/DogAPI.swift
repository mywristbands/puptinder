//
//  DogAPI.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/18/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//
import UIKit
import Foundation

var picID: String = ""
var dogBreed: String = ""

var dogBreeds = ["Affenpinscher":"small", "Afghan Hound":"large", "African Hunting Dog":"large", "Airedale Terrier":"medium", "Akbash Dog":"large", "Akita":"large", "Alapaha Blue Blood Bulldog":"large","Alaskan Husky":"medium","Alaskan Malamute":"large", "American Bulldog":"large", "American Bully":"medium", "American Eskimo Dog":"medium", "American Eskimo Dog (Miniature)":"small", "American Foxhound":"large", "American Pit Bull Terrier":"medium", "American Staffordshire Terrier":"medium","American Water Spaniel":"medium", "Anatolian Shepherd Dog":"large", "Appenzeller Sennenhund":"medium", "Australian Cattle Dog":"medium", "Australian Kelpie":"medium", "Australian Shepherd":"medium","Australian Terrier":"small", "Azawakh":"medium", "Barbet":"medium", "Basenji":"medium", "Basset Bleu de Gascogne":"medium", "Basset Hound":"medium", "Beagle":"medium", "Bearded Collie":"medium", "Beauceron":"large", "Bedlington Terrier":"medium", "Belgian Malinois":"medium", "Belgian Tervuren":"medium", "Bernese Mountain Dog":"large", "Bichon Frise":"small", "Black and Tan Coonhound":"large", "Bloodhound":"large", "Bluetick Coonhound":"medium", "Boerboel":"large", "Border Collie":"medium", "Border Terrier":"small", "Boston Terrier":"medium", "Bouvier des Flandres":"large", "Boxer":"large", "Boykin Spaniel":"medium", "Bracco Italiano":"medium", "Briard":"large", "Brittany":"medium", "Bull Terrier":"medium", "Bull Terrier (Miniature)":"medium", "Bullmastiff":"large", "Cairn Terrier":"small", "Cane Corso":"large", "Cardigan Welsh Corgi":"medium", "Catahoula Leopard Dog":"large", "Caucasian Shepherd (Ovcharka)":"large", "Cavalier King Charles Spaniel":"small", "Chesapeake Bay Retriever":"large", "Chinese Crested":"small", "Chinese Shar-Pei":"medium", "Chinook":"large", "Chow Chow":"medium", "Clumber Spaniel":"large", "Cocker Spaniel":"medium", "Cocker Spaniel (American)":"medium", "Coton de Tulear":"small", "Dalmatian":"medium", "Doberman Pinscher":"large", "Dogo Argentino":"large", "Dutch Shepherd":"medium", "English Setter":"medium", "English Shepherd":"medium", "English Springer Spaniel":"medium", "English Toy Spaniel":"small", "English Toy Terrier":"small", "Eurasier":"medium", "Field Spaniel":"medium", "Finnish Lapphund":"medium", "Finnish Spitz":"medium", "French Bulldog":"medium", "German Pinscher":"medium", "German Shepherd":"large", "German Shorthaired Pointer":"medium", "Giant Schnauzer":"large", "Glen of Imaal Terrier":"medium", "Golden Retriever":"large", "Gordon Setter":"large", "Great Dane":"large", "Great Pyrenees":"large", "Greyhound":"large", "Griffon Bruxellois":"small", "Harrier":"medium", "Havanese":"small", "Husky":"large", "Irish Setter":"medium", "Irish Terrier":"medium", "Irish Wolfhound":"large", "Italian Greyhound":"small", "Japanese Chin":"small", "Japanese Spitz":"medium",  "Keeshond":"medium", "Komondor":"large", "Kooikerhondje":"medium", "Kuvasz":"large", "Labrador Retriever":"large", "Lagotto Romagnolo":"medium", "Lancashire Heeler":"small", "Leonberger":"large", "Lhasa Apso":"small", "Maltese":"small", "Miniature American Shepherd":"medium", "Miniature Pinscher":"small", "Miniature Schnauzer":"small", "Newfoundland":"large", "Norfolk Terrier":"small", "Norwich Terrier":"small", "Nova Scotia Duck Tolling Retriever":"medium", "Old English Sheepdog":"large", "Olde English Bulldogge":"large", "Papillon":"small", "Pekingese":"small", "Pembroke Welsh Corgi":"medium",  "Perro de Presa Canario":"large", "Pharaoh Hound":"medium", "Plott":"medium", "Pomeranian":"small", "Poodle":"medium", "Pug":"small", "Puli":"medium", "Pumi":"medium", "Rat Terrier":"small", "Redbone Coonhound":"medium", "Rhodesian Ridgeback":"large", "Rottweiler":"large", "Russian Toy":"small", "Saint Bernard":"large", "Saluki":"medium", "Samoyed":"large", "Schipperke":"small", "Scottish Deerhound":"large", "Scottish Terrier":"medium", "Shetland Sheepdog":"medium", "Shiba Inu":"medium", "Shih Tzu":"small", "Shiloh Shepherd":"large", "Siberian Husky":"medium", "Silky Terrier":"small", "Smooth Fox Terrier":"small", "Soft Coated Wheaten Terrier":"medium", "Spanish Water Dog":"medium", "Spinone Italiano":"large", "Staffordshire Bull Terrier":"medium", "Standard Schnauzer":"medium", "Swedish Vallhund":"medium", "Thai Ridgeback":"medium", "Tibetan Mastiff":"large",  "Tibetan Spaniel":"small", "Tibetan Terrier":"medium", "Toy Fox Terrier":"small", "Treeing Walker Coonhound":"large", "Vizsla":"large", "Weimaraner":"large", "Welsh Springer Spaniel":"medium", "West Highland White Terrier":"medium", "Whippet":"medium", "White Shepherd":"large", "Wire Fox Terrier":"medium", "Wirehaired Pointing Griffon":"medium", "Wirehaired Vizsla":"medium", "Xoloitzcuintli":"medium", "Yorkshire Terrier":"small"]

func myImageUploadRequest(profImage: UIImage, param: [String:Any], completion: @escaping (_ id: Any?) ->()) {

    let myUrl = NSURL(string: "https://api.thedogapi.com/v1/images/upload")

    let request = NSMutableURLRequest(url:myUrl! as URL);
    request.httpMethod = "POST";

    let boundary = generateBoundaryString()

    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.setValue("47faab64-348b-4cc8-a49a-cc388cc05b7b", forHTTPHeaderField: "x-api-key")


    let imageData = profImage.jpegData(compressionQuality: 1)

    if(imageData==nil)  { return }

    request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data

    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in

        if error != nil {
            print("error=\(String(describing: error))")
            return
        }

        // You can print out response object
        print("******* response = \(String(describing: response))")

        // Print out reponse body
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("****** response data = \(responseString!)")

        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
            let id = json?["id"] as? String
            //picID = id ?? ""
            
            /*DispatchQueue.global(qos: .default).async {
                self.myActivityIndicator.stopAnimating()
                self.myImageView.image = nil;
            }*/
            completion(id)
            
        }catch
        {
            print(error)
        }
    }
    task.resume()
}

func generateBoundaryString() -> String {
    return "--&--"
}


func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> Data {
    var body = Data();

    if parameters != nil {
        for (key, value) in parameters! {
            body.append(Data((key + "=@\(value)").utf8))
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
            body.append(Data("\(value)\r\n".utf8))
        }
    }

    let filename = "user-profile.jpg"
    let mimetype = "image/jpeg"

    body.append(Data("--\(boundary)\r\n".utf8))
    body.append(Data("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".utf8))
    body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
    body.append(imageDataKey as Data)
    body.append(Data("\r\n".utf8))



    body.append(Data("--\(boundary)--\r\n".utf8))

    return body
}

func getDogBreed(pictureID: String, completion: @escaping (_ breed: Any?, _ size: Any?) -> ()) {
    let myUrl = NSURL(string: "https://api.thedogapi.com/v1/images/\(pictureID)/analysis")
    
    let request = NSMutableURLRequest(url:myUrl! as URL);
    request.httpMethod = "GET";
    
    let boundary = generateBoundaryString()

    request.setValue("application/json; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in

        if error != nil {
            print("error=\(String(describing: error))")
            return
        }

        // You can print out response object
        print("******* response = \(String(describing: response))")

        // Print out reponse body
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("****** response data = \(responseString!)")
        var breedFound = false
        
        for(key, value) in dogBreeds {
            //print(key)
            if(responseString?.contains(key) ?? false) {
                breedFound = true
                completion(key, value)
                break
            }
        }
        
        if(!breedFound) {
            completion("not found", "not found")
        }

        /*do {
            /*let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] //NSDictionary
            print(json)
            for(key,_) in json ?? [:] {
                //print(key)
                let keyExists = dogBreeds[key as? String ?? ""] != nil
                
                if keyExists {
                    completion(key)
                }
            }
            let error1 = "error, breed not found"
            completion(error1)*/
            //completion(json)
            //let id = json?["id"] as? String
            //getDogBreedHelper(dogID: id ?? "")
            //{ breed in
            //    completion(breed)
            //}//maybe don't need to have other function return dogBreed and just set and return here
            //completion(dogBreed)
        }catch
        {
            print(error)
        }*/
    }
    task.resume()
}

/*func tryDogBreed(pictureID: String, completion: @escaping (_ breed: Any?) ->()) {
    let myUrl = NSURL(string: "https://api.thedogapi.com/v1/images/\(pictureID)/breeds")

    let request = NSMutableURLRequest(url:myUrl! as URL);
    request.httpMethod = "GET";
    
    let boundary = generateBoundaryString()

    request.setValue("application/json; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in

        if error != nil {
            print("error=\(String(describing: error))")
            return
        }

        // You can print out response object
        print("******* response = \(String(describing: response))")

        // Print out reponse body
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("****** response data = \(responseString!)")

        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
            let id = json?["id"] as? String
            getDogBreedHelper(dogID: id ?? "")
            { breed in
                completion(breed)
            }//maybe don't need to have other function return dogBreed and just set and return here
            //completion(dogBreed)
        }catch
        {
            print(error)
        }
    }
    task.resume()
}

func getDogBreedHelper(dogID: String, completion: @escaping (_ breed: Any?) ->()) {
    let myUrl = NSURL(string: "https://api.thedogapi.com/v1/breeds/\(dogID)")

    let request = NSMutableURLRequest(url:myUrl! as URL);
    request.httpMethod = "GET";
    
    let boundary = generateBoundaryString()

    request.setValue("application/json; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in

        if error != nil {
            print("error=\(String(describing: error))")
            return
        }

        // You can print out response object
        print("******* response = \(String(describing: response))")

        // Print out reponse body
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("****** response data = \(responseString!)")

        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
            //let id = json?["id"] as? String
            //print("JSON\n")
            //print(json)
            dogBreed = json?["name"] as? String ?? ""
            completion(dogBreed)
        }catch
        {
            print(error)
        }
    }
    task.resume()
}*/
