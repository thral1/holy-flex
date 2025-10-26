import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 2560, height: 1600)
    let targetWidth: CGFloat = 1152
    let targetHeight: CGFloat = 917
    let originX = screenFrame.origin.x + (screenFrame.width - targetWidth) / 2
    let originY = screenFrame.origin.y + (screenFrame.height - targetHeight) / 2
    let fixedFrame = NSRect(x: originX, y: originY, width: targetWidth, height: targetHeight)
    self.setFrame(fixedFrame, display: true)
    self.contentViewController = flutterViewController

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
