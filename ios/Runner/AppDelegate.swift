import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // GMSServices.provideAPIKey("AQ.Ab8RN6Jq-L26pVoLTm37m3vVHLFUfnKKBPA4LlNG-Wef1FsvJA") //CLIENT 
    GMSServices.provideAPIKey("AIzaSyANHwsQzGfKQmtizEY7pHApMX4Gvig_OEI") //OFFICE
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
