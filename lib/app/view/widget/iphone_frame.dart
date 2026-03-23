import 'package:flutter/material.dart';
import 'package:device_frame_plus/device_frame_plus.dart';

// FIX 1: Removed unused url_launcher import (caused lint warning).
// FIX 2: Removed unused app_theme import.
// FIX 3: Removed unused width/height params — DeviceFrame controls
// its own sizing based on the SizedBox wrapper in ImageCarousel.
// FIX 4: Removed manual ClipRRect + borderRadius — DeviceFrame already
// clips the screen area correctly; double-clipping caused visual glitches.
// FIX 5: Removed Padding(left: 12) that was off-centering the frame.
// FIX 6: Image fills the frame properly with double.infinity dimensions.
class IphoneFrameWidget extends StatelessWidget {
  final String screenshotPath;

  const IphoneFrameWidget({
    super.key,
    required this.screenshotPath,
  });

  @override
  Widget build(BuildContext context) {
    return DeviceFrame(
      device: Devices.ios.iPhone14Pro,
      screen: Image.asset(
        screenshotPath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}