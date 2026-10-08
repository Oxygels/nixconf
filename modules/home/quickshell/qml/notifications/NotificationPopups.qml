import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.theme

// Stack of notification cards, top-right under the bar.
PanelWindow {
  id: win

  readonly property int maxVisible: 5

  visible: Notifications.list.values.length > 0
  color: "transparent"
  implicitWidth: Theme.notifWidth + 2 * Theme.gap
  implicitHeight: stack.implicitHeight + Theme.gap
  anchors { top: true; right: true }
  margins { top: Theme.barHeight; right: Theme.gap }
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "notifications"
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  Column {
    id: stack
    spacing: Theme.gap

    add: Transition {
      ParallelAnimation {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
        NumberAnimation { property: "x"; from: Theme.notifWidth; duration: 200; easing.type: Easing.OutCubic }
      }
    }
    move: Transition {
      NumberAnimation { property: "y"; duration: 200; easing.type: Easing.OutCubic }
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
