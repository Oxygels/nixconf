import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import qs.components
import qs.theme

Rectangle {
  id: card

  required property var modelData

  readonly property bool critical: modelData.urgency === NotificationUrgency.Critical
  readonly property url iconSource: modelData.image !== ""
    ? modelData.image
    : Quickshell.iconPath(modelData.appIcon, "dialog-information")

  width: Theme.notifWidth
  implicitHeight: content.implicitHeight + 24
  radius: 18
  color: Theme.notifBg
  border.width: critical ? 2 : 0
  border.color: Theme.critical

  // Critical notifications stay until dismissed
  Timer {
    interval: card.modelData.expireTimeout > 0 ? card.modelData.expireTimeout : 5000
    running: !card.critical && card.visible
    onTriggered: card.modelData.expire()
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: card.modelData.dismiss()
  }

  RowLayout {
    id: content
    anchors { fill: parent; margins: 12 }
    spacing: 12

    Image {
      Layout.alignment: Qt.AlignTop
      Layout.preferredWidth: 40
      Layout.preferredHeight: 40
      source: card.iconSource
      sourceSize: Qt.size(80, 80)
      fillMode: Image.PreserveAspectFit
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 4

      Label {
        Layout.fillWidth: true
        text: card.modelData.summary
        elide: Text.ElideRight
        color: card.critical ? Theme.critical : Theme.fg
      }

      Label {
        Layout.fillWidth: true
        visible: text !== ""
        text: card.modelData.body
        textFormat: Text.StyledText
        wrapMode: Text.Wrap
        maximumLineCount: 4
        elide: Text.ElideRight
        color: Theme.subtext
        font.bold: false
      }

      Flow {
        Layout.fillWidth: true
        visible: card.modelData.actions.length > 0
        spacing: 6

        Repeater {
          model: card.modelData.actions

          Rectangle {
            id: btn
            required property var modelData
            implicitWidth: btnLabel.implicitWidth + 20
            implicitHeight: 24
            radius: height / 2
            color: Theme.surface

            Label { id: btnLabel; anchors.centerIn: parent; text: btn.modelData.text; color: Theme.accent }

            MouseArea {
              anchors.fill: parent
              onClicked: btn.modelData.invoke()
            }
          }
        }
      }
    }
  }
}
