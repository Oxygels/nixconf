import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.theme

PanelWindow {
  id: win

  property string query: ""
  readonly property bool open: true
  signal dismissed()

  visible: true
  color: "transparent"
  implicitWidth: 520
  implicitHeight: box.implicitHeight
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "launcher"
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  function close() { dismissed(); }

  Component.onCompleted: search.forceActiveFocus()

  function launch(entry) {
    if (!entry) return;
    Quickshell.execDetached({
      command: ["uwsm", "app", "--"].concat(entry.command),
      workingDirectory: entry.workingDirectory
    });
    close();
  }

  // Rank: name prefix > name substring > other field substring > name subsequence
  function score(e, q) {
    const name = e.name.toLowerCase();
    if (name.startsWith(q)) return 4;
    if (name.includes(q)) return 3;
    const other = ((e.genericName ?? "") + " " + (e.keywords ?? []).join(" ")).toLowerCase();
    if (other.includes(q)) return 2;
    let i = 0;
    for (const c of name) if (c === q[i]) i++;
    return i === q.length ? 1 : 0;
  }

  readonly property var results: {
    const q = query.trim().toLowerCase();
    const apps = DesktopEntries.applications.values.filter(e => !e.noDisplay);
    if (q === "") return apps.sort((a, b) => a.name.localeCompare(b.name));
    return apps
      .map(e => ({ e, s: score(e, q) }))
      .filter(x => x.s > 0)
      .sort((a, b) => b.s - a.s || a.e.name.localeCompare(b.e.name))
      .map(x => x.e);
  }

  HyprlandFocusGrab {
    windows: [win]
    active: win.open
    onCleared: win.close()
  }

  Rectangle {
    id: box
    anchors.fill: parent
    color: Theme.pillBg
    radius: 22
    implicitHeight: col.implicitHeight + 24

    ColumnLayout {
      id: col
      anchors { fill: parent; margins: 12 }
      spacing: 10

      Rectangle {
        Layout.fillWidth: true
        implicitHeight: 40
        radius: height / 2
        color: Theme.surface

        RowLayout {
          anchors { fill: parent; leftMargin: 16; rightMargin: 16 }
          spacing: 10
          Text {
            text: "\uf002"
            color: Theme.accent
            font { family: Theme.fontFamily; pixelSize: 14; bold: true }
          }
          TextInput {
            id: search
            Layout.fillWidth: true
            color: Theme.fg
            selectionColor: Theme.accent
            font { family: Theme.fontFamily; pixelSize: 14; bold: true }
            onTextChanged: { win.query = text; list.currentIndex = 0; }
            Keys.onEscapePressed: win.close()
            Keys.onReturnPressed: win.launch(win.results[list.currentIndex])
            Keys.onEnterPressed: win.launch(win.results[list.currentIndex])
            Keys.onDownPressed: list.incrementCurrentIndex()
            Keys.onUpPressed: list.decrementCurrentIndex()
            Keys.onPressed: ev => {
              if (ev.modifiers & Qt.ControlModifier) {
                if (ev.key === Qt.Key_J) { list.incrementCurrentIndex(); ev.accepted = true; }
                else if (ev.key === Qt.Key_K) { list.decrementCurrentIndex(); ev.accepted = true; }
              }
            }
          }
        }
      }

      ListView {
        id: list
        Layout.fillWidth: true
        implicitHeight: Math.min(count, 8) * 44
        visible: count > 0
        clip: true
        spacing: 4
        model: win.results
        currentIndex: 0
        highlightMoveDuration: 100
        boundsBehavior: Flickable.StopAtBounds

        delegate: Rectangle {
          id: row
          required property var modelData
          required property int index
          width: list.width
          height: 40
          radius: height / 2
          color: ListView.isCurrentItem ? Theme.selected : "transparent"

          RowLayout {
            anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
            spacing: 10
            IconImage {
              implicitSize: 24
              source: Quickshell.iconPath(row.modelData.icon, "application-x-executable")
            }
            Text {
              Layout.fillWidth: true
              text: row.modelData.name
              elide: Text.ElideRight
              color: row.ListView.isCurrentItem ? Theme.accent : Theme.fg
              font { family: Theme.fontFamily; pixelSize: 14; bold: true }
            }
          }

          MouseArea {
            anchors.fill: parent
            onClicked: win.launch(row.modelData)
          }
        }
      }
    }
  }
}
