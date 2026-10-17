import QtQuick
import Quickshell.Io
import qs.components
import qs.services

Stat {
  icon: Audio.muted ? "" : ""
  value: Audio.muted ? "muted" : Audio.volume + "%"

  onClicked: Audio.toggleMute()
  onRightClicked: pavucontrolProc.running = true
  onWheeled: delta => Audio.adjust(delta > 0 ? 0.05 : -0.05)

  Process { id: pavucontrolProc; command: ["pavucontrol"] }
}
