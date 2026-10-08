pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// Owns org.freedesktop.Notifications. Every incoming notification is tracked
// and stays in `list` until it is dismissed or expires.
Singleton {
  readonly property alias list: server.trackedNotifications

  NotificationServer {
    id: server
    bodySupported: true
    bodyMarkupSupported: true
    actionsSupported: true
    imageSupported: true

    onNotification: n => n.tracked = true
  }
}
