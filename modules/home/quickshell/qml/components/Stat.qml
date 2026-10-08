import QtQuick
import qs.theme

// Pill with an accent-coloured icon followed by a value.
Pill {
  property string icon
  property string value

  Label { text: icon; color: Theme.accent }
  Label { text: value }
}
