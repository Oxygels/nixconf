//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.bar
import qs.launcher
import qs.notifications
import qs.osd
import qs.services

ShellRoot {
  // Bar, one per screen
  Variants {
    model: Quickshell.screens
    Bar {}
  }

  // Bar.qml and NotificationPopups.qml react to Hyprland.toplevels[].lastIpcObject.fullscreen,
  // but that's only kept current by an explicit refresh — toggling fullscreen on an existing
  // window (as opposed to opening a new one) doesn't always trigger one on its own. Force a
  // refresh on the events that actually change fullscreen/monitor state.
  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (["fullscreen", "openwindow", "closewindow", "movewindow"].includes(event.name)) {
        Hyprland.refreshToplevels();
      }
    }
  }

  // Launcher, created on demand: `quickshell ipc call launcher toggle`
  LazyLoader {
    id: launcherLoader
    Launcher { onDismissed: launcherLoader.active = false }
  }

  IpcHandler {
    target: "launcher"
    function toggle(): void { launcherLoader.active = !launcherLoader.active; }
  }

  // Notifications (the Notifications singleton owns the D-Bus name)
  NotificationPopups {}

  // Volume OSD, shown briefly on volume change
  VolumeOsd {}

  // Touch DesktopEntries at startup so the .desktop scan isn't paid on first launcher open
  readonly property int _appCount: DesktopEntries.applications.values.length
}
