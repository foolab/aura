import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "file:///usr/lib/qt4/imports/com/nokia/extras/constants.js" as ExtrasConstants
import aura.controller 1.0
import aura.viewfinder 1.0

Item {
    id: page
    width: screen.displayWidth; height: screen.displayHeight

    Component.onCompleted: {
        screen.allowedOrientations = Screen.Landscape
        console.debug("program loaded")
    }

    property bool windowActive : platformWindow.active
    property int animationDuration: 150
    property bool recording: false

    Item {
        id: mainPage
        anchors.fill: parent

        Connections {
            target: platformWindow

            onActiveChanged: {
                if (platformWindow.active) {
                    controller.startPipeline()
                } else {
                    controller.stopPipeline()
                }
            }
        }

        ViewFinder {
            id: viewFinder
            anchors.fill: parent

            Rectangle {
                id: viewFinderColorkeyPainter
                anchors.fill: parent
                color: "#080810"

                Component.onCompleted: console.debug("viewfinder colorkey painted")
            }
        }

        Controller {
            id: controller
            viewFinder: viewFinder
            Component.onCompleted: setup()
        }

        Effects {
            id: effects
            animationDuration: page.animationDuration
        }

        ToolIcon {
            id: shutter
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            iconId: "camera-shutter"
            opacity: effects.visible ? 0 : 1
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: animationDuration } }
            onClicked: {
                console.debug("shutter clicked")
                recording = !recording
                controller.shutterClicked()
            }
        }

        ToolIcon {
            id: conf
            anchors {
                right: parent.right
                bottom: parent.bottom
            }
            iconId: "toolbar-view-menu"
            opacity: effects.visible || recording ? 0 : 1
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: animationDuration } }
            onClicked: effects.show()
        }
    }
}
