//
//  PDFVC.swift
//  BookXpertAssignment
//
//  Created by Avinash Verma on 24/05/25.
//

import UIKit
import PDFKit

class PDFVC: UIViewController {
    
    @IBOutlet weak var pdfViewer: UIView!
    
    private var pdfView: PDFView!
    private var notFoundLabel: UILabel!
    
    var url = "https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPDFView()
        if let url = URL(string: url) {
            fetchPDF(from: url, into: pdfView)
        }
    }
    
    
    private func setupPDFView() {
        pdfView = PDFView(frame: pdfViewer.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        pdfViewer.addSubview(pdfView)
    }
    
    private func fetchPDF(from url: URL, into pdfView: PDFView) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("PDF load error: \(error)")
                
                return
            }
            
            guard let data = data, let document = PDFDocument(data: data) else {
                
                return
            }
            
            DispatchQueue.main.async {
                pdfView.document = document
            }
        }
        task.resume()
    }
    
    
}
