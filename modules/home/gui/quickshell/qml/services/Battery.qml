pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Battery capacity / status. available is false when the host has no battery.
Singleton {
  id: root

  property int _capacity: -1
  property string _status: ""

  readonly property bool available: _capacity >= 0
  readonly property int capacity: _capacity
  readonly property bool charging: _status === "Charging" || _status === "Full"
  readonly property real fraction: available ? _capacity / 100 : 0

  Process {
    id: proc
    command: ["sh", "-c", "for b in /sys/class/power_supply/BAT*; do [ -r \"$b/capacity\" ] && cat $b/capacity $b/status; done"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n");
        let cap = -1, status = "";
        for (let i = 0; i + 1 < lines.length; i += 2) {
          const c = parseInt(lines[i]);
          if (!isNaN(c) && c > cap) {
            cap = c;
            status = lines[i + 1].trim();
          }
        }
        root._capacity = cap;
        root._status = status;
      }
    }
  }

  Timer {
    interval: 5000; running: true; repeat: true; triggeredOnStart: true
    onTriggered: proc.running = true
  }
}
