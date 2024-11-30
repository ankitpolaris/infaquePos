//
//  HttpUtility.swift
//  infaquePos
//
//  Created by Ankit Khanna on 27/11/24.
//

import Foundation
import UIKit


// {"which": "login"}

struct LoginViewModel: Decodable {
    var id: String?
    var username: String?
    var firstname: String?
    var lastname: String?
}

struct LoginResultModel: Decodable {
    var result: String?
    var data: LoginViewModel?
}

class ViewController: UIViewController {

    var httpUtility = HTTPUtility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginBtnTapped(_ sender: UIButton) {
        
        let urlString = "https://mangosoftwarelab.in/api/"
        let param : [String: String] = ["which": "login"]
        
        Task {
            do {
                let result = try await httpUtility.apiRequestWithAsyncAwait(urlString: urlString, parameters: param, method: "POST")
                print(result.data ?? "")
            }
            catch {
                
            }
        }
        
    }
    
}


class HTTPUtility: NSObject {
    
    
    
    
    //  MARK: - API Request Method using Async Await
    
    // {"which" : "login"}
    func apiRequestWithAsyncAwait(urlString: String, parameters: [String: String], method: String) async throws -> LoginResultModel {
        
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = method
        
        guard let httpHody = try? JSONSerialization.data(withJSONObject: parameters) else { return LoginResultModel() }
        
        requestURL.httpBody = httpHody
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let (data, response) =  try await session.data(for: requestURL)
        
        let httpReponse = response as? HTTPURLResponse
        let statusCode = httpReponse?.statusCode ?? 0
        print("HTTP Response: %@", statusCode)
        
        let jsonObject = try JSONDecoder().decode(LoginResultModel.self, from: data)
        
        return jsonObject
        
    }
    
    
}
