import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // Set window to be narrower (600pt) and vertically maximized
    if let screen = NSScreen.main {
      let screenFrame = screen.visibleFrame // Use visibleFrame to respect menu bar and dock
      let width: CGFloat = 600
      let height = screenFrame.height
      let x = screenFrame.midX - width / 2
      let y = screenFrame.minY

      let newFrame = NSRect(x: x, y: y, width: width, height: height)
      self.setFrame(newFrame, display: true)
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
