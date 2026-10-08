pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// Default output sink volume / mute.
Singleton {
  readonly property var sink: Pipewire.defaultAudioSink?.audio ?? null
  readonly property bool muted: sink ? sink.muted : false
  readonly property int volume: sink ? Math.round(sink.volume * 100) : 0

  PwObjectTracker { objects: [Pipewire.defaultAudioSink] }

  function toggleMute() {
    if (sink) sink.muted = !sink.muted;
  }

  function adjust(delta) {
    if (sink) sink.volume = Math.max(0, Math.min(1, sink.volume + delta));
  }
}
