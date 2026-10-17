import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.components
import qs.services
import qs.theme

// Centered line popup shown briefly on volume change.
PanelWindow {
  id: win

  // Same fullscreen-avoidance as NotificationPopups.qml: an empty layer-shell
  // surface still blocks tearing on its monitor, so keep off any fullscreen screen.
  function isFullscreenOn(s) {
    const monName = Hyprland.monitorFor(s)?.name;
    return Hyprland.toplevels.values.some(t => t.monitor?.name === monName && t.lastIpcObject.fullscreen === 2);
  }
  readonly property var freeScreen: Quickshell.screens.find(s => !isFullscreenOn(s))
  screen: freeScreen ?? Quickshell.screens[0]

  // Ignore the initial binding as Audio connects to the real sink on startup.
  property bool ready: false
  Component.onCompleted: Qt.callLater(() => ready = true)

  // Kept separate from hideTimer.running: restarting an already-running Timer
  // toggles running false→true in the same tick, which would replay the
  // opacity fade-in on every repeat keypress instead of just extending it.
  property bool shown: false
  function pulse() { shown = true; hideTimer.restart(); }

  Connections {
    target: Audio
    function onVolumeChanged() { if (win.ready) win.pulse(); }
    function onMutedChanged() { if (win.ready) win.pulse(); }
  }

  Timer { id: hideTimer; interval: 1200; onTriggered: win.shown = false }

  visible: freeScreen !== undefined && shown
  color: "transparent"
  implicitWidth: 240
  implicitHeight: Theme.pillHeight + 2 * Theme.gap
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "volume-osd"
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  Rectangle {
    anchors.fill: parent
    radius: height / 2
    color: Theme.pillBg

    opacity: win.shown ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 150 } }

    Row {
      anchors { fill: parent; leftMargin: Theme.gap * 2; rightMargin: Theme.gap * 2 }
      spacing: Theme.gap

      Label {
        id: icon
        anchors.verticalCenter: parent.verticalCenter
        text: Audio.muted ? "🔇" : Audio.volume >= 50 ? "🔊" : "🔉"
        color: Audio.muted ? Theme.dim : Theme.fg
      }

      Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - parent.spacing * 2 - icon.width - pct.width
        height: 6
        radius: height / 2
        color: Theme.surface

        Rectangle {
          height: parent.height
          radius: parent.radius
          color: Audio.muted ? Theme.dim : Theme.accent
          width: parent.width * (Audio.muted ? 0 : Audio.volume / 100)
          Behavior on width { NumberAnimation { duration: 120 } }
        }
      }

      Label {
        id: pct
        anchors.verticalCenter: parent.verticalCenter
        text: Audio.muted ? "muted" : Audio.volume + "%"
        color: Theme.subtext
      }
    }
  }
}
