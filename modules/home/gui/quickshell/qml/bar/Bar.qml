import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.components
import qs.services
import qs.theme

PanelWindow {
  id: bar

  required property var modelData

  screen: modelData
  color: "transparent"
  implicitHeight: Theme.barHeight
  anchors { top: true; left: true; right: true }

  // Left
  WindowTitle {
    maxWidth: bar.width * 0.3
    anchors { left: parent.left; leftMargin: Theme.gap; verticalCenter: parent.verticalCenter }
  }

  // Center
  Row {
    anchors.centerIn: parent
    spacing: Theme.gap

    Clock {}
    Workspaces { monitor: Hyprland.monitorFor(bar.modelData) }
  }

  // Right
  Row {
    anchors { right: parent.right; rightMargin: Theme.gap; verticalCenter: parent.verticalCenter }
    spacing: Theme.gap

    Tray { window: bar }
    Stat { icon: ""; value: Stats.cpu + "%" }
    Stat { icon: ""; value: Stats.mem + "%" }
    Stat { visible: Stats.gpu >= 0; icon: ""; value: Stats.gpu + "%" }
    NetworkSpeed {}
    Volume {}
  }
}
