import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.components

Pill {
  id: root

  // Window the context menus are anchored to.
  required property var window

  visible: SystemTray.items.values.length > 0

  Repeater {
    model: SystemTray.items

    Item {
      id: entry
      required property SystemTrayItem modelData

      Layout.preferredWidth: 18
      Layout.preferredHeight: 18

      IconImage {
        anchors.fill: parent
        source: entry.modelData.icon
      }

      QsMenuAnchor {
        id: menuAnchor
        menu: entry.modelData.menu
        anchor.window: root.window
        anchor.rect.x: entry.mapToItem(null, 0, 0).x
        anchor.rect.y: root.window.height
        anchor.rect.width: entry.width
        anchor.rect.height: 1
      }

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        onClicked: mouse => {
          const it = entry.modelData;
          if (mouse.button === Qt.LeftButton && !it.onlyMenu) it.activate();
          else if (mouse.button === Qt.MiddleButton) it.secondaryActivate();
          else if (it.hasMenu) menuAnchor.open();
        }
      }
    }
  }
}
