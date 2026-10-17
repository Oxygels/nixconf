pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// CPU / memory / GPU usage in percent. gpu is -1 when no supported GPU is found.
Singleton {
  id: root

  property int cpu: 0
  property int mem: 0
  property int nvidiaGpu: -1
  property int amdGpu: -1
  readonly property int gpu: Math.max(nvidiaGpu, amdGpu)

  property var _lastCpu: [0, 0]

  FileView { id: statFile; path: "/proc/stat" }
  FileView { id: memFile; path: "/proc/meminfo" }

  function _updateProc() {
    statFile.reload();
    memFile.reload();

    const statLine = statFile.text().split("\n")[0];
    if (statLine) {
      const c = statLine.split(/\s+/).slice(1).map(Number);
      const idle = c[3] + c[4];
      const total = c.reduce((a, b) => a + b, 0);
      const dt = total - _lastCpu[0], di = idle - _lastCpu[1];
      if (dt > 0) cpu = Math.round(100 * (dt - di) / dt);
      _lastCpu = [total, idle];
    }

    const m = memFile.text();
    const totMatch = m.match(/MemTotal:\s+(\d+)/);
    const avMatch = m.match(/MemAvailable:\s+(\d+)/);
    if (totMatch && avMatch) {
      const tot = parseInt(totMatch[1]);
      const av = parseInt(avMatch[1]);
      mem = Math.round(100 * (tot - av) / tot);
    }
  }

  Process {
    id: nvidiaProc
    command: ["sh", "-c", "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null"]
    stdout: StdioCollector {
      onStreamFinished: {
        const v = parseInt(text.trim());
        root.nvidiaGpu = isNaN(v) ? -1 : v;
      }
    }
  }

  Process {
    id: amdProc
    command: ["sh", "-c", "cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null"]
    stdout: StdioCollector {
      onStreamFinished: {
        const v = text.trim().split("\n").map(x => parseInt(x)).filter(x => !isNaN(x));
        root.amdGpu = v.length ? Math.max(...v) : -1;
      }
    }
  }

  Timer {
    interval: 2000; running: true; repeat: true; triggeredOnStart: true
    onTriggered: {
      root._updateProc();
      nvidiaProc.running = true;
      amdProc.running = true;
    }
  }
}
