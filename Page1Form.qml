import QtQuick 2.11
import QtQuick.Controls 2.4
import QtLocation 5.11
import QtPositioning 5.11
import QtLocation 5.9
import QtPositioning 5.8
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.15


Page {
    //title: qsTr("Карта")
    id: mapPage
    title: {
        if (items_1.map_mode == "enemy"){
            qsTr("Карта (пометка противника)")
        } else if (items_1.map_mode == "move"){
            qsTr("Карта (приказ передвижения)")
        }
        else {
            qsTr("Карта (промотр)")
        }
    }

    Label {
        anchors.fill: parent
        anchors.centerIn: parent

        //        PositionSource {
        //          id: src
        //          updateInterval: 1000 * 5
        //          active: true
        //          preferredPositioningMethods: PositionSource.SatellitePositioningMethods
        //          Component.onCompleted: {
        //            src.start()
        //            console.log("supported methods: ", src.supportedPositioningMethods)
        //            console.log(sourceError)
        //            console.log("coordinates: ", src.position.coordinate)
        //              console.log("IsValid: ",src.position.coordinate.isvalid)
        //          }
        //          onPositionChanged: {
        //            var coord = src.position.coordinate
        //              test_1.text = src.position.coordinate.latitude + "/" + src.position.coordinate.longitude
        //              var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance
        //              var theUrl = "http://**.**.**.***:8000/users_coordinates";
        //              xmlhttp.open("POST", theUrl);
        //              console.log("Position changed" + coord.latitude, coord.longitude)
        //              xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        //              //xmlhttp.send(JSON.stringify({"name":items_1.name_auth_name,"lat":src.position.coordinate.latitude, "lon":src.position.coordinate.longitude, "color": "red", "status":items_1.status}))
        //              xmlhttp.send(JSON.stringify({"name":items_1.name_auth_name,"lat":coord.latitude, "lon":coord.longitude, "color": "red", "status":items_1.status}))
        //          }
        //        }

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

        Plugin {
            id: mapPlugin
            name: "osm" // "mapboxgl", "esri", ...
            PluginParameter {
                name: "osm.mapping.providersrepository.disabled"
                value: "true"
            }
            PluginParameter {
                name: "osm.mapping.providersrepository.address"
                value: "http://maps-redirect.qt.io/osm/5.6/"
            }
        }


        Map {
            //anchors.bottomMargin: 30
            id: map
            anchors.fill: parent
            //center: QtPositioning.coordinate(59.938630, 30.314130)
            center: QtPositioning.coordinate(items_1.current_lat, items_1.current_lon)
            zoomLevel: items_1.current_zoom
            plugin: mapPlugin


            ListModel {
                id: mapModel
            }



            function getData() {
                var xmlhttp = new XMLHttpRequest()
                var url
                if (items_1.user_map_mode == "ally"){
                    url = "http://" + items_1.server_url + "/alive_users_coordinates"
                } else {
                    url = "http://" + items_1.server_url + "/alive_users_coordinates1"
                }
                xmlhttp.onreadystatechange = function () {
                    if (xmlhttp.readyState == XMLHttpRequest.DONE) {
                        //console.log(xmlhttp)
                        myFunction(xmlhttp.responseText)
                    }
                }
                xmlhttp.open("GET", url, true)
                xmlhttp.send()
            }

            function myFunction(response) {
                mapModel.clear()
                //console.log(response)
                var arr = JSON.parse(response)
                for (var i = 0; i < arr.length; i++) {
                    mapModel.append({
                                        "lon": arr[i].lon,
                                        "lat": arr[i].lat,
                                        "name": arr[i].name,
                                        "color": arr[i].color
                                    })
                }
            }

            function loadData(){
                var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance
                var theUrl = "http://" + items_1.server_url + "/users_coordinates";
                xmlhttp.open("POST", theUrl);
                xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
                //xmlhttp.send(JSON.stringify({"name":items_1.name_auth_name,"lat":src.position.coordinate.latitude, "lon":src.position.coordinate.longitude, "color": "red", "status":items_1.status}))
                console.log(src.position.coordinate.latitude)
                xmlhttp.send(JSON.stringify({"name":items_1.name_auth_name,"lon":src.position.coordinate.latitude, "lat":src.position.coordinate.longitude, "color": "green", "status":items_1.status}))
            }

            Timer {
                interval: 1000 * 1
                repeat: true
                running: true
                onTriggered: {
                    src.start()
                    //console.log("updating new data")
                    map.getData()
                    //console.log(items_1.name_auth_name)
                    map.loadData()
                }
            }

            Timer{
                interval: 1000
                repeat: true
                running: true
                onTriggered: {
                    src.start()
//                    console.log("supported methods: ", src.supportedPositioningMethods)
//                    console.log("NoPositioningMethods ",src.supportedPositioningMethods == PositionSource.NoPositioningMethods)
//                    console.log("SatellitePositioningMethods",src.supportedPositioningMethods == PositionSource.SatellitePositioningMethods)
//                    console.log("NonSatellitePositioningMethods",src.supportedPositioningMethods == PositionSource.NonSatellitePositioningMethods)
//                    console.log("AllPositioningMethods",src.supportedPositioningMethods == PositionSource.AllPositioningMethods)
//                    console.log(src.sourceError)
//                    console.log("seom: ", src.position.coordinate)
//                    console.log("soem1: ",src.position.coordinate.isvalid)
                }
            }

//            Timer{
//                interval: 1000
//                repeat: true
//                running: true
//                onTriggered: {
//                    items_1.current_lat = map.center.latitude
//                    items_1.current_lon = map.center.longitude
//                }
//            }

            MapItemView {
                // telemetry
                model: mapModel
                delegate: MapQuickItem {
                    Component.onCompleted: {
                        //console.log("circle drawen: ", name, lat, lon)
                    }

                    coordinate: QtPositioning.coordinate(lon, lat)

                    anchorPoint.x: image.width * 0.5
                    anchorPoint.y: image.height

                    sourceItem: Column {
                        //Image { id: image; source: "marker.png" }
                        Image { id: image; source: "marker_" + color + ".png" }
                        Text { text: name; font.bold: true }
                    }
                    //Deleting
                    MouseArea{
                        pressAndHoldInterval: 500
                        anchors.fill: parent
                        onPressAndHold: {
                            console.log(name, lat, lon)
                            var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance
                            var theUrl = "http://" + items_1.server_url + "/users_coordinates";
                            xmlhttp.open("POST", theUrl);
                            xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
                            //xmlhttp.send(JSON.stringify({"name":items_1.name_auth_name,"lat":src.position.coordinate.latitude, "lon":src.position.coordinate.longitude, "color": "red", "status":items_1.status}))
                            console.log(color)
                            xmlhttp.send(JSON.stringify({"name":name,"lat":lat, "lon":lon, "color": color, "status":"dead"}))

                        }
                    }
                }
            }

            Timer{
                id: addedMarker
                running: false
                repeat: false
                interval: 1000
                onTriggered: {
                    marker_text.text = ""
                    stop()
                }
            }

            //Adding on map
            MouseArea {
                enabled: {
                    items_1.map_mode == "enemy" || items_1.map_mode == "move"
                }
                anchors.fill: parent
                pressAndHoldInterval: 500
//                onPressed: {
//                    //console.log(map.toCoordinate(Qt.point(mouse.x,mouse.y)))
//                    //mapModel.append({"lon": QtPositioning.coordinate(map.toCoordinate(Qt.point(mouse.x))), "lat": QtPositioning.coordinate(map.toCoordinate(Qt.point(mouse.y))), "name": "someus"})
//                    //console.log("ssssss",QtPositioning.coordinate(map.toCoordinate(Qt.point(mouse.x, mouse.y))))
//                    var click_coord = map.toCoordinate(Qt.point(mouse.x, mouse.y))
//                    console.log(click_coord.latitude, click_coord.longitude)
//                    var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance
//                    var theUrl = "http://**.**.**.***:8000/users_coordinates";
//                    xmlhttp.open("POST", theUrl);
//                    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
//                    //xmlhttp.send(JSON.stringify({"name":items_1.name_auth_name,"lat":src.position.coordinate.latitude, "lon":src.position.coordinate.longitude, "color": "red", "status":items_1.status}))
//                    xmlhttp.send(JSON.stringify({"name":items_1.enemy_string,"lon":click_coord.latitude, "lat":click_coord.longitude, "color": "red", "status":"alive"}))
//                }
                onPressAndHold: {
                    //console.log(map.toCoordinate(Qt.point(mouse.x,mouse.y)))
                    //mapModel.append({"lon": QtPositioning.coordinate(map.toCoordinate(Qt.point(mouse.x))), "lat": QtPositioning.coordinate(map.toCoordinate(Qt.point(mouse.y))), "name": "someus"})
                    //console.log("ssssss",QtPositioning.coordinate(map.toCoordinate(Qt.point(mouse.x, mouse.y))))
                    var click_coord = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                    var local_color = items_1.map_mode == "enemy" ? "red" : "blue"
                    var local_name = items_1.map_mode == "enemy" ? items_1.enemy_string : items_1.move_string
                    console.log(click_coord.latitude, click_coord.longitude)
                    var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance
                    var theUrl = "http://" + items_1.server_url + "/users_coordinates";
                    xmlhttp.open("POST", theUrl);
                    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
                    //xmlhttp.send(JSON.stringify({"name":items_1.name_auth_name,"lat":src.position.coordinate.latitude, "lon":src.position.coordinate.longitude, "color": "red", "status":items_1.status}))
                    xmlhttp.send(JSON.stringify({"name":local_name,"lon":click_coord.latitude, "lat":click_coord.longitude, "color": local_color, "status":"alive"}))
                    marker_text.text = "отмечен: " + local_name
                    console.log(mapModel.color)
                    addedMarker.start()
                }
            }
        }
    }




    GridLayout{
        id: grid
//        Button{
//            text: "Режим карты"
//            onClicked: {
//                items_1.current_zoom = map.zoomLevel
//                items_1.current_lat = map.center.latitude
//                items_1.current_lon = map.center.longitude
//                stackView.push("Page4Form.qml")
//                drawer.close()
//            }
//        }
        Button{
            Layout.row: 0
            Layout.column: 0
            text: "Центрировать карту"
            onClicked: {
                var coord1 = src.position.coordinate
//                map.center = QtPositioning.coordinate(59.938630, 30.314130)
                map.center = QtPositioning.coordinate(coord1.latitude, coord1.longitude)
            }
        }
        Button{
            Layout.row: 1
            Layout.column: 0
            height: 300
            id: button_2
            Component.onCompleted: {
                if (items_1.user_map_mode == "ally"){
                    button_2.text = "Отображать только союзников"
                } else{
                    button_2.text = "Отображать всё"
                }
            }

            onClicked: {
                if (items_1.user_map_mode == "all"){
                    button_2.text = "Отображать только союзников"
                    items_1.user_map_mode = "ally"
                } else{
                    button_2.text = "Отображать всё"
                    items_1.user_map_mode = "all"
                }
                console.log(items_1.user_map_mode)
            }
        }
        Label{
            Layout.row: 1
            Layout.column: 0
            id: marker_text
            //text: "отмечен: " + items_1.enemy_string
        }
    }
    GridLayout{

    }

    //    Label{
    //        id: test_1
    //        height: 30
    //        text: src.position.coordinate.latitude + "/" + src.position.coordinate.longitude
    //    }
}
