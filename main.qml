import QtQuick 2.11
import QtQuick.Controls 2.4
import QtLocation 5.11
import QtPositioning 5.11

ApplicationWindow {
    id: window
    visible: true
    title: qsTr("Stack")

    Item{
        id: items_1
        property string name_auth_name: ""
        property string server_url: "**.**.**.***:8000"
        property var longitude_coordinates
        property string status: "alive"
        property string map_mode: "look"
        property string user_map_mode: "ally"
        property string enemy_string
        property string move_string
        property var current_zoom: 10
        property var current_coord
        property var current_lat: 59.938630
        property var current_lon: 30.314130
        property var current_server
        property var current_name
    }

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
//                if (stackView.depth > 2) {
//                    stackView.pop()
//                } else {
//                    drawer.open()
//                }
                drawer.open()
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }
    }

    Drawer {
        id: drawer
        width: window.width * 0.66
        height: window.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("Карта")
                width: parent.width
                onClicked: {
                    stackView.push("Page1Form.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Список участников")
                width: parent.width
                onClicked: {
                    stackView.push("Page2Form.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Профиль")
                width: parent.width
                onClicked: {
                    stackView.push("Page3Form.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Режим карты")
                width: parent.width
                onClicked: {
                    stackView.push("Page4Form.qml")
                    drawer.close()
                }
            }
        }
    }

    StackView {
        id: stackView
        initialItem: "HomeForm.qml"
        anchors.fill: parent
    }
}
