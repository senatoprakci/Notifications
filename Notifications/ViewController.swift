//
//  ViewController.swift
//  Notifications
//
//  Created by Sena Toprakcı on 7.03.2024.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    var izinKontrol = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
       
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {
            granted , error in
            
            self.izinKontrol = granted
            
            if granted {
                print("izin alma başarılı")
            }else {
                print("izin alma başarısız")
            }
        })
    }

    @IBAction func buttonBildirimOlustur(_ sender: Any) {
        if izinKontrol {
            let icerik = UNMutableNotificationContent()
            icerik.title = "Başlık"
            icerik.subtitle = "Alt Başlık"
            icerik.body = "Mesaj"
            icerik.badge = 1 //ikonun üstündeki bildirim sayısı
            icerik.sound = UNNotificationSound.default
            
            let tetikleme = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) //bildirimin zamansal olarak tetiklenmesi
            
            let bildirimIstek = UNNotificationRequest(identifier: "id", content: icerik, trigger: tetikleme)
            
            UNUserNotificationCenter.current().add(bildirimIstek)
        }
    }
    
}

extension ViewController : UNUserNotificationCenterDelegate {
    
    //uygulama açıkken bildirim gönderen fonksiyon
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound,.badge])
    }
    //bildirime tıklanan fonksiyon
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let app = UIApplication.shared
        app.applicationIconBadgeNumber = 0 //bildirime tıklandığında badge değerini sıfırlar
        
        if app.applicationState == .active {
            print("ön planda bildirim seçildi")
        }
        
        if app.applicationState == .inactive {
            print("arka planda bildirim seçildi")
        }
        
        completionHandler()
    }
}
