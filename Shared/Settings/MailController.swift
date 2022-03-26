//
//  MailController.swift
//  FuriganaPDFView
//
//  Created by Morten Bertz on 2021/05/25.
//  Copyright © 2021 telethon k.k. All rights reserved.
//

import Foundation
import SwiftUI
import MessageUI


//https://stackoverflow.com/questions/56784722/swiftui-send-email
struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.view.tintColor = UIColor(named: "AccentColor")
        vc.setToRecipients(["support@telethon.jp"])
        let sysVersion=UIDevice.current.systemVersion
        let subject=String(format: NSLocalizedString("Feedback %@ %@ (Build %@) on iOS %@", comment: "feedback String"), Bundle.main.applicationName, Bundle.main.version, Bundle.main.build, sysVersion)
        
        vc.setSubject(subject)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}
