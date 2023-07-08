import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    title: qsTr("Режим карты")

    GridLayout{

        Button{
            text: "Просмотр"
            Layout.column:1
            Layout.row: 0
            onClicked: {
                items_1.map_mode = "look"
                stackView.push("Page1Form.qml")
                drawer.close()
            }
        }
        TextField{
            id: enemy_string_id
            text: items_1.enemy_string
            Layout.row: 1
            Layout.column: 0
        }
        Button{
            text: "Режим Противник"
            Layout.column:1
            Layout.row: 1
            onClicked: {
                items_1.map_mode = "enemy"
                items_1.enemy_string = enemy_string_id.text
                items_1.move_string = move_string_id.text
                stackView.push("Page1Form.qml")
                drawer.close()
            }
        }
        TextField{
            id: move_string_id
            text: items_1.move_string
            Layout.row: 2
            Layout.column: 0
        }

        Button{
            Layout.row: 2
            Layout.column: 1
            text: "Режим передвижение"
            onClicked: {
                items_1.map_mode = "move"
                items_1.enemy_string = enemy_string_id.text
                items_1.move_string = move_string_id.text
                stackView.push("Page1Form.qml")
                drawer.close()
            }
        }
    }
}
