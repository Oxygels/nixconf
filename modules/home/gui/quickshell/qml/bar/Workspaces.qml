import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.components
import qs.theme

Pill {
  id: root

  property var monitor
  property int count: 6

  Repeater {
    model: root.count

    Item {
      id: slot
      required property int index
      readonly property bool active: root.monitor?.activeWorkspace?.id === index + 1

      Layout.preferredWidth: 14
      Layout.preferredHeight: 14

      Rectangle {
        anchors.centerIn: parent
        width: slot.active ? 12 : 8
        height: width
        radius: width / 2
        color: slot.active ? Theme.accent : Theme.dim

        Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 200 } }
      }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("workspace " + (slot.index + 1))
      }
    }
  }
}
