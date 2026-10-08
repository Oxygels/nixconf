pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Network throughput in bytes/s, summed over physical interfaces.
Singleton {
  property real down: 0
  property real up: 0

  property var _last: null

  readonly property var _ignored: /^(lo|veth|docker|br-|virbr|tun|tap|wg)/

  FileView { id: netFile; path: "/proc/net/dev" }

  function _update() {
    netFile.reload();
    let rx = 0, tx = 0;
    for (const line of netFile.text().split("\n").slice(2)) {
      const [name, data] = line.split(":");
      if (!data || _ignored.test(name.trim())) continue;
      const f = data.trim().split(/\s+/).map(Number);
      rx += f[0];
      tx += f[8];
    }
    const now = Date.now();
    if (_last) {
      const dt = (now - _last.t) / 1000;
      if (dt > 0) {
        down = Math.max(0, (rx - _last.rx) / dt);
        up = Math.max(0, (tx - _last.tx) / dt);
      }
    }
    _last = { rx, tx, t: now };
  }

  // Compact, fixed-width human readable rate, e.g. "  1.2M", "  340K"
  function format(bps) {
    const units = ["B", "K", "M", "G"];
    let v = bps, i = 0;
    while (v >= 1000 && i < units.length - 1) { v /= 1024; i++; }
    const s = (v < 10 && i > 0 ? v.toFixed(1) : Math.round(v).toString()) + units[i];
    return s.padStart(5, " ");
  }

  Timer {
    interval: 1000; running: true; repeat: true; triggeredOnStart: true
    onTriggered: _update()
  }
}
