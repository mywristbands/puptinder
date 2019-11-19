//
//  DogAPI.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/18/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//
import UIKit
import Foundation

/*struct Response : Decodable {
    let code : Int
    let hasError : Bool
    let message : String
    let data : [Session]
}

struct Session : Decodable {
    let userSession: String
}

func getPostString(params:[String:Any]) -> String
{
    var data = [String]()
    for(key, value) in params
    {
        data.append(key + "=\(value)")
    }
    return data.map { String($0) }.joined(separator: "&")
}

func callPost(url:URL, params:[String:Any], finish: @escaping ((message:String, data:Data?)) -> Void)
{
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let postString = getPostString(params: params)
    request.httpBody = postString.data(using: .utf8)

    var result:(message:String, data:Data?) = (message: "Fail", data: nil)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in

        if(error != nil)
        {
            result.message = "Fail Error not null : \(error.debugDescription)"
        }
        else
        {
            result.message = "Success"
            result.data = data
        }

        finish(result)
    }
    task.resume()
}

func finishPost (message:String, data:Data?) -> Void
{
    do
    {
        if let jsonData = data
        {
            let parsedData = try JSONDecoder().decode(Response.self, from: jsonData)
            print(parsedData)
        }
    }
    catch
    {
        print("Parse Error: \(error)")
    }
}*/

func myImageUploadRequest(profImage: UIImage, param: [String:Any])
{

    let myUrl = NSURL(string: "https://api.thedogapi.com/v1/images/upload")

    let request = NSMutableURLRequest(url:myUrl! as URL);
    request.httpMethod = "POST";

    //let param = [
    //    "firstName"  : "Sergey",
    //]

    let boundary = generateBoundaryString()

    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.setValue("47faab64-348b-4cc8-a49a-cc388cc05b7b", forHTTPHeaderField: "x-api-key")


    let imageData = profImage.jpegData(compressionQuality: 1)

    if(imageData==nil)  { return; }

    request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data


    //myActivityIndicator.startAnimating();

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

            print(json as Any)

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
