import QtQuick
import qs.components
import qs.services

Stat {
  visible: Battery.available

  icon: {
    if (Battery.charging) return "󰂄";
    const f = Battery.fraction;
    if (f >= 0.75) return "󰁹";
    if (f >= 0.5) return "󰁼";
    if (f >= 0.3) return "󰁻";
    if (f >= 0.15) return "󰁺";
    return "󰂎";
  }
  value: Battery.capacity + "%"
}
