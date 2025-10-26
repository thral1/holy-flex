import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let screen = NSScreen.main
    let screenFrame = screen?.frame ?? NSRect(x: 0, y: 0, width: 2560, height: 1600)
    let targetPointWidth: CGFloat = 400
    let targetHeight: CGFloat = 917
    let originX = screenFrame.midX - targetPointWidth / 2
    let originY = screenFrame.midY - targetHeight / 2
    let fixedFrame = NSRect(x: originX, y: originY, width: targetPointWidth, height: targetHeight)
    self.setFrame(fixedFrame, display: true)
    self.contentViewController = flutterViewController

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
