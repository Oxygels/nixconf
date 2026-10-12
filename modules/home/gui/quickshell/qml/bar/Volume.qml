import QtQuick
import qs.components
import qs.services

Stat {
  icon: Audio.muted ? "" : ""
  value: Audio.muted ? "muted" : Audio.volume + "%"

  onClicked: Audio.toggleMute()
  onWheeled: delta => Audio.adjust(delta > 0 ? 0.05 : -0.05)
}
