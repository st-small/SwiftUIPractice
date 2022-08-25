//
//  CertificateViewModel.swift
//  SwiftUICombineAndData
//
//  Created by Stanly Shiyanovskiy on 22.08.2022.
//

import Firebase
import Foundation

final class CertificateViewModel: ObservableObject {
    @Published var certificates: [Certificate] = []
    
    init() {
        fetchCertificates()
    }
    
    func fetchCertificates() {
        let db = Firestore.firestore()
        
        db.collection("certificates").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        
                        let id = data["id"] as? String ?? ""
                        let course = data["course"] as? String ?? ""
                        let dateValue = (data["date"] as AnyObject).dateValue()
                        let date = dateValue.formatDate()
                        let logo = data["logo"] as? String ?? ""
                        let instructor = data["instructor"] as? String ?? ""
                        
                        let certificate = Certificate(id: id, course: course, date: date, logo: logo, instructor: instructor)
                        self?.certificates.append(certificate)
                    }
                }
            }
        }
    }
}
