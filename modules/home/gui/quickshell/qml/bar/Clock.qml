import QtQuick
import Quickshell
import qs.components
import qs.theme

Pill {
  SystemClock { id: clock; precision: SystemClock.Minutes }

  Label { text: ""; color: Theme.peach }
  Label { text: Qt.formatTime(clock.date, "HH:mm") }
}
