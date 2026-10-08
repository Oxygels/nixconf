import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.components

Pill {
  readonly property string title: Hyprland.activeToplevel?.title ?? ""

  visible: title !== ""

  Label {
    Layout.maximumWidth: 600
    elide: Text.ElideRight
    text: title
  }
}
