import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtPositioning 5.11

Page {
    title: qsTr("Профиль")

    GridLayout{
        id: grid1
        Layout.column: 5
        rows: 5

        Label{
            id: auth
            text: ""
            Layout.row:0
            Layout.column:3
            Layout.columnSpan: 5
            Layout.alignment: "AlignHCenter"
        }

        Label{
            text: "Позывной: "
            Layout.row:1
            Layout.column:1
        }

        TextField{
            id: profile_name
            text: items_1.name_auth_name
            Layout.row:1
            Layout.column:2
        }

        Label{
            text: "Сервер: "
            Layout.row:2
            Layout.column:1
        }

        TextField{
            id: profile_server
            text: items_1.server_url
            Layout.row:2
            Layout.column:2
        }

        Label{
            text: "Статус: "
            Layout.row:3
            Layout.column:1
        }

        Label{
            text: items_1.status
            Layout.row:3
            Layout.column:2
        }

        Button{
            id: buttonus
            Layout.row:3
            Layout.column:3
            text: "Изменить статус"
            onClicked: {
                if (items_1.status == "alive"){
                    items_1.status = "dead"
                } else {
                    items_1.status = "alive"
                }
            }
        }

        PositionSource {
            id: src
            updateInterval: 1000
            preferredPositioningMethods: PositionSource.SatellitePositioningMethods
            active: true
            name: "geoclue2"

            onPositionChanged: {
                var coord = position.coordinate;
                console.log("Coordinate:", coord.longitude, coord.latitude);
            }
        }

        Button{
            id: buttonu1
            Layout.row:5
            Layout.column:3
            text: "Сохранить изменения"
            onClicked: {
                items_1.server_url = profile_server.text
                items_1.name_auth_name = profile_name.text

                    var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance
                    var theUrl = "http://" + items_1.server_url + "/users_coordinates";
                    xmlhttp.open("POST", theUrl);
                    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
                    //xmlhttp.send(JSON.stringify({"name":items_1.name_auth_name,"lat":src.position.coordinate.latitude, "lon":src.position.coordinate.longitude, "color": "red", "status":items_1.status}))
                    console.log(src.position.coordinate.latitude)
                    xmlhttp.send(JSON.stringify({"name":items_1.name_auth_name,"lon":src.position.coordinate.latitude, "lat":src.position.coordinate.longitude, "color": "green", "status":"dead"}))

            }
        }
    }
}
