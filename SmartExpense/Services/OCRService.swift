import Vision
import UIKit

class OCRService {
    static let shared = OCRService()

    struct OCRResult {
        var amounts: [Double] = []
        var merchant: String?
        var allText: String
    }

    func recognizeText(from image: UIImage, completion: @escaping (Result<OCRResult, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(NSError(domain: "OCRService", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法获取图片"])))
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.failure(NSError(domain: "OCRService", code: -2, userInfo: [NSLocalizedDescriptionKey: "无法识别文字"])))
                return
            }

            var allText = ""
            var amounts: [Double] = []

            for observation in observations {
                if let topCandidate = observation.topCandidates(1).first {
                    let text = topCandidate.string
                    allText += text + "\n"

                    let extractedAmounts = self.extractAmounts(from: text)
                    amounts.append(contentsOf: extractedAmounts)
                }
            }

            let merchant = self.extractMerchant(from: allText)

            let result = OCRResult(amounts: Array(Set(amounts)), merchant: merchant, allText: allText)
            completion(.success(result))
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["zh-Hans", "zh-Hant", "en-US"]

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func extractAmounts(from text: String) -> [Double] {
        var amounts: [Double] = []

        let patterns = [
            "¥\\s*(\\d+\\.?\\d*)",
            "(\\d+\\.\\d{2})",
            "RMB\\s*(\\d+\\.?\\d*)",
            "金额[:：]\\s*(\\d+\\.?\\d*)",
            "实付[:：]\\s*(\\d+\\.?\\d*)",
            "支付[:：]\\s*(\\d+\\.?\\d*)",
            "总计[:：]\\s*(\\d+\\.?\\d*)",
            "价格[:：]\\s*(\\d+\\.?\\d*)"
        ]

        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let range = NSRange(text.startIndex..., in: text)
                let matches = regex.matches(in: text, options: [], range: range)

                for match in matches {
                    if match.numberOfRanges >= 2,
                       let amountRange = Range(match.range(at: 1), in: text) {
                        let amountString = String(text[amountRange])
                        if let amount = Double(amountString), amount > 0 && amount < 100000 {
                            amounts.append(amount)
                        }
                    }
                }
            }
        }

        return amounts
    }

    private func extractMerchant(from text: String) -> String? {
        let merchantKeywords = [
            "星巴克", "瑞幸", "luckin",
            "美团", "饿了么",
            "盒马", "永辉", "沃尔玛", "家乐福",
            "天猫", "京东", "淘宝", "拼多多",
            "滴滴", "高德", "地铁", "公交",
            "麦当劳", "肯德基", "汉堡王",
            "房租", "水电", "物业",
            "医院", "药店", "诊所"
        ]

        for keyword in merchantKeywords {
            if text.contains(keyword) {
                return keyword
            }
        }

        return nil
    }
}
