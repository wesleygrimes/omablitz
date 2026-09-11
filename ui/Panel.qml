import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui

// Following + Game share this panel; payload.mode picks which view.
Item {
  id: root

  property var shell: null
  property var manifest: null
  property bool opened: false
  property string mode: "following"

  function open(payloadJson) {
    try {
      var p = JSON.parse(payloadJson || "{}") || {}
      root.mode = p.mode || "following"
    } catch (e) {
      root.mode = "following"
    }
    root.opened = true
  }

  function close() {
    root.opened = false
  }

  function dismiss() {
    if (root.shell && typeof root.shell.hide === "function")
      root.shell.hide((root.manifest && root.manifest.id) || "pro.grimes.omablitz")
    else
      close()
  }

  PanelWindow {
    visible: root.opened
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    anchors {
      top: true
      bottom: true
      left: true
      right: true
    }

    // Click-away dismiss.
    MouseArea {
      anchors.fill: parent
      onClicked: root.dismiss()
    }

    Rectangle {
      anchors.centerIn: parent
      width: 320
      height: 200
      radius: Style.cornerRadius
      color: Color.background
      border.color: Color.accent
      border.width: 1

      // Stop click-away when interacting with the card.
      MouseArea {
        anchors.fill: parent
        onClicked: {}
      }

      Column {
        anchors.centerIn: parent
        spacing: Style.space(8)

        Text {
          textFormat: Text.PlainText
          text: "Omablitz"
          color: Color.foreground
          font.family: Style.font.family
          font.pixelSize: Style.font.title
          font.bold: true
          anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
          textFormat: Text.PlainText
          text: root.mode === "game" ? "Game" : "Following"
          color: Color.accent
          font.family: Style.font.family
          font.pixelSize: Style.font.body
          anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
          textFormat: Text.PlainText
          text: "Stub — build this next."
          color: Color.foreground
          opacity: 0.6
          font.family: Style.font.family
          font.pixelSize: Style.font.caption
          anchors.horizontalCenter: parent.horizontalCenter
        }
      }
    }

    Keys.onEscapePressed: root.dismiss()
  }
}
