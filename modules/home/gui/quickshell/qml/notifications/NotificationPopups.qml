import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.services
import qs.theme

// Stack of notification cards, top-right under the bar.
PanelWindow {
  id: win

  readonly property int maxVisible: 5

  // A mapped layer-shell surface on a monitor blocks Hyprland's scanout/tearing
  // path there even while empty, so always steer this window away from whichever
  // monitor currently has a fullscreen client. If every monitor is fullscreened
  // (including single-monitor setups), there's nowhere safe to put it, so unmap
  // it entirely instead of blocking tearing on the only screen available.
  function isFullscreenOn(s) {
    const monName = Hyprland.monitorFor(s)?.name;
    return Hyprland.toplevels.values.some(t => t.monitor?.name === monName && t.lastIpcObject.fullscreen === 2);
  }
  readonly property var freeScreen: Quickshell.screens.find(s => !isFullscreenOn(s))
  screen: freeScreen ?? Quickshell.screens[0]

  // The surface is fixed-size and always mapped, with input limited to the cards.
  // Resizing or re-mapping the layer surface per notification caused visible glitches.
  visible: freeScreen !== undefined
  color: "transparent"
  implicitWidth: Theme.notifWidth + 2 * Theme.gap
  implicitHeight: screen?.height ?? 1000
  mask: Region { item: stack }
  anchors { top: true; right: true }
  margins { top: Theme.barHeight; right: Theme.gap }
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "notifications"
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  Column {
    id: stack
    x: Theme.gap
    spacing: Theme.gap

    add: Transition {
      ParallelAnimation {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 180 }
        NumberAnimation { property: "x"; from: Theme.notifWidth / 2; to: 0; duration: 180; easing.type: Easing.OutCubic }
      }
    }
    move: Transition {
      NumberAnimation { property: "y"; duration: 180; easing.type: Easing.OutCubic }
    }

    Repeater {
      model: Notifications.list

      NotificationCard {
        required property int index
        visible: index < win.maxVisible
      }
    }
  }
}
