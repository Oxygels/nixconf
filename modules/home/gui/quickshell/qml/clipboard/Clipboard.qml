import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
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
  WlrLayershell.namespace: "clipboard"
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  function close() { dismissed(); }

  Component.onCompleted: { listProc.running = true; search.forceActiveFocus(); }

  // cliphist list lines look like "<id>\t<preview>"
  property var entries: []
  readonly property string thumbDir: Quickshell.cacheDir + "/clipboard-thumbs"

  // Image previews look like "[[ binary data 2 MiB png 1699x1396 ]]"
  function parseImage(preview) {
    const m = preview.match(/^\[\[ binary data [\d.]+\s*[A-Za-z]*B\s+(\w+)\s+(\d+)x(\d+)\s*\]\]$/);
    return m ? { ext: m[1], w: parseInt(m[2]), h: parseInt(m[3]) } : null;
  }

  function select(entry) {
    if (!entry || !/^\d+$/.test(entry.id)) return;
    // Detached: closing this window (killing its child Processes) must not
    // race the copy, which can take a while to finish for large images.
    Quickshell.execDetached(["sh", "-c", "cliphist decode " + entry.id + " | wl-copy"]);
    close();
  }

  function score(e, q) {
    const p = e.preview.toLowerCase();
    if (p.startsWith(q)) return 2;
    if (p.includes(q)) return 1;
    return 0;
  }

  readonly property var results: {
    const q = query.trim().toLowerCase();
    if (q === "") return entries;
    return entries
      .map(e => ({ e, s: score(e, q) }))
      .filter(x => x.s > 0)
      .sort((a, b) => b.s - a.s)
      .map(x => x.e);
  }

  Process {
    id: listProc
    command: ["cliphist", "list"]
    stdout: StdioCollector {
      onStreamFinished: {
        win.entries = text.split("\n").filter(l => l.length > 0).map(line => {
          const i = line.indexOf("\t");
          const id = i >= 0 ? line.slice(0, i) : line;
          const preview = i >= 0 ? line.slice(i + 1) : line;
          return { id, preview, image: win.parseImage(preview) };
        });
      }
    }
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
            text: ""
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
            Keys.onReturnPressed: win.select(win.results[list.currentIndex])
            Keys.onEnterPressed: win.select(win.results[list.currentIndex])
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
          property string thumbPath: ""
          width: list.width
          height: 40
          radius: height / 2
          color: ListView.isCurrentItem ? Theme.selected : "transparent"

          Component.onCompleted: {
            const img = row.modelData.image;
            if (!img || !/^\d+$/.test(row.modelData.id)) return;
            const path = win.thumbDir + "/" + row.modelData.id + "." + img.ext;
            thumbProc.path = path;
            thumbProc.command = ["sh", "-c",
              "mkdir -p '" + win.thumbDir + "' && { [ -f '" + path + "' ] || cliphist decode " + row.modelData.id + " > '" + path + "'; }"];
            thumbProc.running = true;
          }

          Process {
            id: thumbProc
            property string path: ""
            onExited: (code) => { if (code === 0) row.thumbPath = path; }
          }

          RowLayout {
            anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
            spacing: 10

            Image {
              visible: row.thumbPath !== ""
              Layout.preferredWidth: 32
              Layout.preferredHeight: 32
              fillMode: Image.PreserveAspectCrop
              source: row.thumbPath !== "" ? "file://" + row.thumbPath : ""
              asynchronous: true
            }

            Text {
              Layout.fillWidth: true
              text: row.modelData.preview
              elide: Text.ElideRight
              verticalAlignment: Text.AlignVCenter
              color: row.ListView.isCurrentItem ? Theme.accent : Theme.fg
              font { family: Theme.fontFamily; pixelSize: 14; bold: true }
            }
          }

          MouseArea {
            anchors.fill: parent
            onClicked: win.select(row.modelData)
          }
        }
      }
    }
  }
}
