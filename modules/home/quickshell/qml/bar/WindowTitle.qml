import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.components

Pill {
  property real maxWidth: 600
  readonly property string title: Hyprland.activeToplevel?.title ?? ""

  visible: title !== ""

  Label {
    Layout.maximumWidth: Math.max(0, maxWidth)
    elide: Text.ElideRight
    text: title
  }
}
