# Install Xcode Manually for iOS Development

The automated installation didn't work because you need to manually install Xcode from the App Store.

## Option 1: Install from App Store (Easiest)

1. **Open the App Store** on your Mac
2. **Search for "Xcode"**
3. **Click "Get" or "Install"**
4. **Wait for download** (~15GB, takes 30-60 minutes depending on internet speed)
5. **After installation completes:**

```bash
# Configure Xcode
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# Accept license
sudo xcodebuild -license accept

# Install additional components
xcodebuild -downloadAllPlatforms
```

6. **Then run Holy Flex on iOS:**

```bash
cd /Users/Josiah.Kung/Downloads/holy_flex
open -a Simulator
flutter run
```

## Option 2: Download Directly from Apple (Faster for some)

1. Go to: https://developer.apple.com/download/all/
2. Search for "Xcode"
3. Download the latest Xcode .xip file
4. Double-click to extract (takes a while)
5. Move Xcode.app to /Applications/
6. Run the configuration commands above

## Option 3: Use Your Physical iPhone (No Xcode Needed!)

If you have your iPhone with you, you can skip Xcode and test directly:

1. **Connect iPhone to Mac via USB**
2. **Trust this computer** on iPhone (popup will appear)
3. **Run:**
```bash
cd /Users/Josiah.Kung/Downloads/holy_flex
flutter run
```

Flutter will automatically install Holy Flex on your connected iPhone!

**Note:** First time may ask you to:
- Enable Developer Mode on iPhone (Settings → Privacy & Security → Developer Mode)
- Trust your developer certificate on iPhone (Settings → General → VPN & Device Management)

## After Xcode is Installed

Once Xcode is installed, come back and run:

```bash
cd /Users/Josiah.Kung/Downloads/holy_flex
flutter doctor  # Should show ✓ for Xcode
flutter run     # Will launch on iOS Simulator
```

---

**For now, you have 3 choices:**

1. ⏳ **Wait for Xcode to install from App Store** (30-60 min)
2. 📱 **Use your physical iPhone** (if you have it with you)
3. 🌐 **Continue testing in Chrome** (already working)

Let me know which you prefer!
