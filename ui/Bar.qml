import QtQuick
import Quickshell
import qs.Ui
import qs.Commons
import "../lib/Format.js" as Format

// Year-round mark + gameday pills live here later.
BarWidget {
  id: root
  moduleName: "pro.grimes.omablitz"

  // mise.dev sets OMABLITZ_API_BASE to the mock; unset → production.
  readonly property string apiBase: Format.apiBase()

  implicitWidth: mark.implicitWidth + Style.space(8)
  implicitHeight: barSize

  Text {
    id: mark
    anchors.centerIn: parent
    textFormat: Text.PlainText
    text: "OB"
    color: root.bar ? root.bar.barForeground : Color.foreground
    font.family: root.bar ? root.bar.fontFamily : Style.font.family
    font.pixelSize: Style.font.body
    font.bold: true
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton
    onClicked: {
      Quickshell.execDetached([
        "omarchy", "shell", "shell", "toggle", "pro.grimes.omablitz",
        JSON.stringify({ mode: "following" })
      ])
    }
  }
}
