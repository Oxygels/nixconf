pragma Singleton
import QtQuick
import Quickshell

// Catppuccin Mocha
Singleton {
  readonly property color pillBg: "#e61e1e2e"
  readonly property color notifBg: "#991e1e2e"
  readonly property color surface: "#313244"
  readonly property color selected: "#45475a"
  readonly property color fg: "#cdd6f4"
  readonly property color dim: "#585b70"
  readonly property color accent: "#94e2d5"
  readonly property color peach: "#fab387"
  readonly property color subtext: "#a6adc8"
  readonly property color critical: "#f38ba8"

  readonly property string fontFamily: "CaskaydiaCove Nerd Font"
  readonly property int fontSize: 13

  readonly property int barHeight: 40
  readonly property int pillHeight: 30
  readonly property int gap: 8
  readonly property int notifWidth: 360
}
