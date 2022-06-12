//
//  ImageManager.swift
//  ImagePickerTest
//
//  Created by 김민재 on 2022/06/10.
//

import SwiftUI

/*
 * 시스템 데이터이므로 실제 사용할때는 .applicationDirectory를 기본 디렉토리로 사용해야 함
 *
 * 저장되는 이미지 파일을 확인하려면 기본 디렉토리를 .documentDirectory로 설정한 후 프로젝트의 plist에서
 * Supports opening documents in place -> Yes
 * Application supports iTunes file sharing -> Yes
 * 로 설정해줘야 함
 */

class UIImageFileManager {
    static let shared = UIImageFileManager()  // 전역 저장
    private let forDir = FileManager.SearchPathDirectory.applicationDirectory
    
    private init(){}    // 인스턴스 생성 방지용
    
    // 저장
    func saveImage(image: UIImage, path: String = "", fileName: String) -> Bool {
        
        // 이미지 전처리
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        
        // FileManager 설정
        guard let directoryURL = try? FileManager.default.url(for: forDir, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path) else {
            return false
        }
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        // 경로상의 디렉토리 생성
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        // 저장
        do {
            try data.write(to: fileURL)
            return true
        } catch let e {
            print(e.localizedDescription)
            return false
        }
    }
    
    // 읽기
    func getSavedImage(path: String = "", fileName: String) -> UIImage? {
        if let directoryURL = try? FileManager.default.url(for: forDir, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path).appendingPathComponent(fileName) {
            return UIImage(contentsOfFile: directoryURL.path)
        }
        return nil
    }
    
    // 삭제하기
    func deleteSavedImage(path: String = "", fileName: String) -> Bool {
        do {
            try FileManager.default.removeItem(at: FileManager.default.url(for: forDir, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path).appendingPathComponent(fileName))
            return true
        } catch let e {
            print(e.localizedDescription)
            return false
        }
    }
}
