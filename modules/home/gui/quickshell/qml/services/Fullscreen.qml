pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

// Which screens have a fullscreen client. A mapped layer-shell surface on a monitor
// forces Hyprland to composite every frame there (no direct scanout, no tearing),
// even while empty, so the bar/popups unmap or move away from fullscreen screens.
Singleton {
  function isOn(screen) {
    const monName = Hyprland.monitorFor(screen)?.name;
    // `fullscreen` is a bitmask (1 = maximized, 2 = fullscreen); check only the fullscreen bit.
    return Hyprland.toplevels.values.some(t => t.monitor?.name === monName && (t.lastIpcObject.fullscreen & 2) !== 0);
  }

  // First screen without a fullscreen client, or undefined if every screen has one.
  readonly property var freeScreen: Quickshell.screens.find(s => !isOn(s))

  // lastIpcObject.fullscreen is only kept current by an explicit refresh; toggling
  // fullscreen on an existing window doesn't always trigger one on its own.
  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (["fullscreen", "openwindow", "closewindow", "movewindow"].includes(event.name)) {
        Hyprland.refreshToplevels();
      }
    }
  }
}
