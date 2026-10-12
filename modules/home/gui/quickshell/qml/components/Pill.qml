import QtQuick
import QtQuick.Layouts
import qs.theme

// Rounded bubble. Children are laid out in a row inside it.
Rectangle {
  default property alias content: row.data

  signal clicked()
  signal wheeled(int delta)

  color: Theme.pillBg
  radius: height / 2
  implicitHeight: Theme.pillHeight
  implicitWidth: row.implicitWidth + 24

  MouseArea {
    anchors.fill: parent
    onClicked: parent.clicked()
    onWheel: wheel => parent.wheeled(wheel.angleDelta.y)
  }

  RowLayout {
    id: row
    anchors.centerIn: parent
    spacing: Theme.gap
  }
}
