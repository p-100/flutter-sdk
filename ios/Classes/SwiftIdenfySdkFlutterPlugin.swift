import Flutter
import UIKit
import iDenfySDK
import idenfycore
import idenfyviews

public class SwiftIdenfySdkFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "idenfy_sdk_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftIdenfySdkFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getPlatformVersion" {
          result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "start" {
            if let arguments = call.arguments as? [String: Any],
               let authToken = arguments["authToken"] as? String {

                //Changing common iDenfy colors
                IdenfyCommonColors.idenfyMainColorV2 = UIColor.green
                IdenfyCommonColors.idenfyMainDarkerColorV2 = UIColor.green
                IdenfyCommonColors.idenfySecondColorV2 = UIColor.black
                IdenfyCommonColors.idenfyBackgroundColorV2 = UIColor.white

                //Customizing Tooblar
                IdenfyToolbarUISettingsV2.idenfyDefaultToolbarLogoIconTintColor = UIColor.blue
                IdenfyToolbarUISettingsV2.idenfyDefaultToolbarBackIconTintColor = UIColor.blue
                IdenfyToolbarUISettingsV2.idenfyLanguageSelectionToolbarLanguageSelectionIconTintColor = UIColor.yellow
                IdenfyToolbarUISettingsV2.idenfyLanguageSelectionToolbarCloseIconTintColor = UIColor.blue
                IdenfyToolbarUISettingsV2.idenfyCameraPreviewSessionToolbarBackIconTintColor = UIColor.white

                //Changing specific screen colors (Every screen has its own UI Settings class)
                IdenfyDocumentSelectionViewUISettingsV2.idenfyDocumentSelectionViewBackgroundColor = UIColor.white
                IdenfyDocumentSelectionViewUISettingsV2.idenfyDocumentSelectionViewTitleTextColor = UIColor.black
                IdenfyDocumentSelectionViewUISettingsV2.idenfyDocumentSelectionViewDocumentTableViewCellBorderColor = UIColor.brown

                //Changeing specific screen fonts (Every screen has its own UI Settings class)
                IdenfyDocumentSelectionViewUISettingsV2.idenfyDocumentSelectionViewTitleFont = UIFont.systemFont(ofSize: 20)
                IdenfyDocumentSelectionViewUISettingsV2.idenfyDocumentSelectionViewDocumentTypeFont = UIFont.systemFont(ofSize: 14)
                IdenfyDocumentSelectionViewUISettingsV2.idenfyDocumentSelectionViewDocumentTypeHighlightedFont = UIFont.boldSystemFont(ofSize: 14)

                let idenfySettingsV2 = IdenfyBuilderV2()
                    .withAuthToken(authToken)
                    .withIdenfyToolbarHidden()
                    .build()

                let idenfyViewsV2: IdenfyViewsV2 = IdenfyViewsBuilderV2()
                    .withSplashScreenV2View(SplashScreenV2View())
                    .withProviderSelectionView(ProviderSelectionViewV2())
                    .withProviderCellView(ProviderCell.self)
                    .withProviderLoginView(ProviderLoginViewV2())
                    .withMFAMethodSelectionView(MFAMethodSelectionViewV2())
                    .withMFAGeneralView(MFAGeneralViewV2())
                    .withMFACaptchaView(MFACaptchaViewV2())
                    .withNFCRequiredView(NFCRequiredViewV2())
                    .withIssuedCountryView(IssuedCountryViewV2())
                    .withCountrySelectionView(CountrySelectionViewV2())
                    .withCountryCellView(CountryCell.self)
                    .withLanguageSelectionView(LanguageSelectionViewV2())
                    .withLanguageCellView(LanguageCell.self)
                    .withDocumentSelectionView(DocumentSelectionViewV2())
                    .withDocumentCellView(DocumentCell.self)
                    .withConfirmationView(ConfirmationViewV2())
                    .withDynamicCameraOnBoardingView(DynamicCameraOnBoardingViewV2())
                    .withStaticCameraOnBoardingView(StaticCameraOnBoardingViewV2())
                    .withCameraOnBoardingInstructionDescriptionsCellView(InstructionDescriptionsCellV2.self)
                    .withConfirmationViewDocumentStepCellView(DocumentStepCell.self)
                    .withCameraPermissionView(CameraPermissionViewV2())
                    .withDrawerContentView(DrawerContentViewV2())
                    .withUploadPhotoView(UploadPhotoViewV2())
                    .withDocumentCameraView(DocumentCameraViewV2())
                    .withCameraWithRectangleResultViewV2(DocumentCameraResultViewV2())
                    .withPdfResultView(PdfResultViewV2())
                    .withFaceCameraView(FaceCameraViewV2())
                    .withCameraWithoutRectangleResultViewV2(FaceCameraResultViewV2())
                    .withNFCReadingView(NFCReadingViewV2())
                    .withNFCReadingTimeOutView(NFCReadingTimeOutViewV2())
                    .withIdentificationResultsView(IdentificationResultsViewV2())
                    .withIdentificationResultsStepCellView(ResultsStepCell.self)
                    .withIdentificationSuccessResultsView(IdentificationSuccessResultsViewV2())
                    .withIdentificationSuspectedResultsView(IdentificationSuspectedResultsViewV2())
                    .withManualReviewingStatusWaitingView(ManualReviewingStatusWaitingViewV2())
                    .withManualReviewingStatusFailedView(ManualReviewingStatusFailedViewV2())
                    .withManualReviewingStatusApprovedView(ManualReviewingStatusApprovedViewV2())
                    .withAdditionalSupportView(AdditionalSupportViewV2())
                    .withFaceAuthenticationSplashScreenV2View(FaceAuthenticationSplashScreenV2View())
                    .withFaceAuthenticationResultsViewV2(FaceAuthenticationResultsViewV2())
                    .build()

                let idenfyController = IdenfyController.shared
                idenfyController.initializeIdenfySDKV2WithManual(idenfySettingsV2: idenfySettingsV2, idenfyViewsV2: idenfyViewsV2)
                let idenfyVC = idenfyController.instantiateNavigationController()

                UIApplication.shared.keyWindow?.rootViewController?.present(idenfyVC, animated: true, completion: nil)

                idenfyController.handleIdenfyCallbacksWithManualResults(idenfyIdentificationResult: {
                    idenfyIdentificationResult
                    in
                    do {
                        let jsonEncoder = JSONEncoder()
                        let jsonData = try jsonEncoder.encode(idenfyIdentificationResult)
                        let string = String(data: jsonData, encoding: String.Encoding.utf8)
                        result(string)
                    } catch {
                    }
                })
            }
        } else if call.method == "startFaceAuth" {
            if let arguments = call.arguments as? [String: Any],
               let withImmediateRedirect = arguments["withImmediateRedirect"] as? Bool,
               let authenticationToken = arguments["token"] as? String {
                let idenfyFaceAuthUISettings = IdenfySettingsDecoder.decodeFaceAuthUISettings(arguments["idenfyFaceAuthUISettings"] as? [String : AnyObject?])
                let idenfyController = IdenfyController.shared
                let faceAuthenticationInitialization = FaceAuthenticationInitialization(authenticationToken: authenticationToken, withImmediateRedirect: withImmediateRedirect, idenfyFaceAuthUISettings: idenfyFaceAuthUISettings)
                idenfyController.initializeFaceAuthentication(faceAuthenticationInitialization: faceAuthenticationInitialization)
                let idenfyVC = idenfyController.instantiateNavigationController()
                
                UIApplication.shared.keyWindow?.rootViewController?.present(idenfyVC, animated: true, completion: nil)
                
                idenfyController.handleIdenfyCallbacksForFaceAuthentication(faceAuthenticationResult: { faceAuthenticationResult in
                    do {
                        let jsonEncoder = JSONEncoder()
                        let jsonData = try jsonEncoder.encode(faceAuthenticationResult)
                        let string = String(data: jsonData, encoding: String.Encoding.utf8)
                        result(string)
                    } catch {
                    }
                })
            }
        }
    }
}

class IdenfySettingsDecoder {
    
    static func decodeFaceAuthUISettings(_ json: [String: AnyObject?]?) -> IdenfyFaceAuthUISettings {
        let faceAuthUISettings = IdenfyFaceAuthUISettings()
        if let unwrappedLanguageSelectionNeeded = json?["isLanguageSelectionNeeded"] as? Bool {
            faceAuthUISettings.isLanguageSelectionNeeded = unwrappedLanguageSelectionNeeded
        }
        if let unwrappedSkipOnBoardingView = json?["skipOnBoardingView"] as? Bool {
            faceAuthUISettings.skipOnBoardingView = unwrappedSkipOnBoardingView
        }
        return faceAuthUISettings
    }
}
