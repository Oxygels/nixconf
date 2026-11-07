//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Io
import qs.bar
import qs.clipboard
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

  // Launcher, created on demand: `quickshell ipc call launcher toggle`
  LazyLoader {
    id: launcherLoader
    Launcher { onDismissed: launcherLoader.active = false }
  }

  IpcHandler {
    target: "launcher"
    function toggle(): void { launcherLoader.active = !launcherLoader.active; }
  }

  // Clipboard history, created on demand: `quickshell ipc call clipboard toggle`
  LazyLoader {
    id: clipboardLoader
    Clipboard { onDismissed: clipboardLoader.active = false }
  }

  IpcHandler {
    target: "clipboard"
    function toggle(): void { clipboardLoader.active = !clipboardLoader.active; }
  }

  // Notifications (the Notifications singleton owns the D-Bus name)
  NotificationPopups {}

  // Volume OSD, shown briefly on volume change
  VolumeOsd {}

  // Touch DesktopEntries at startup so the .desktop scan isn't paid on first launcher open
  readonly property int _appCount: DesktopEntries.applications.values.length
}
