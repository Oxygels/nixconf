import QtQuick
import qs.components
import qs.services
import qs.theme

Pill {
  Label { text: ""; color: Theme.accent }
  Label { text: Network.format(Network.down) }
  Label { text: ""; color: Theme.peach }
  Label { text: Network.format(Network.up) }
}
