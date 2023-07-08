import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    GridLayout{
        id: grid1
        //Layout.column: 5
        rows: 5

        Label{
            id: auth
            text: "Авторизация"
            Layout.row:0
            Layout.column:3
            Layout.columnSpan: 5
            Layout.alignment: "AlignHCenter"
        }

        Label{
            text: "Позывной"
            Layout.row:1
            Layout.column:1
        }

        TextField{
            id: login_name
            Layout.row:1
            Layout.column:2
        }

        Label{
            text: "Сервер"
            Layout.row:2
            Layout.column:1
        }

        TextField{
            id: enter_server
            text: items_1.server_url
            Layout.row:2
            Layout.column:2
        }

        Button{
            id: buttonus
            Layout.row:3
            Layout.column:3
            text: "Войти в систему"
            onClicked: {
                items_1.name_auth_name = login_name.text
                items_1.server_url = enter_server.text
                console.log(items_1.name_auth_name)
                stackView.push("Page1Form.qml")
            }
        }
    }
}
