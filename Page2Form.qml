import QtQuick 2.11
import QtQuick.Controls 2.4

Page {
    title: qsTr("Список личного состава")

    ListModel {
      id: mapModel1
    }

    function getData1() {
        var xmlhttp = new XMLHttpRequest()
        var url = "http://" + items_1.server_url + "/users_coordinates"

        xmlhttp.onreadystatechange = function () {
          if (xmlhttp.readyState == XMLHttpRequest.DONE) {
              //console.log(xmlhttp)
            myFunction1(xmlhttp.responseText)
          }
        }
        xmlhttp.open("GET", url, true)
        xmlhttp.send()
      }

    function myFunction1(response) {
        mapModel1.clear()
          //console.log(response)
        var arr = JSON.parse(response)
        for (var i = 0; i < arr.length; i++) {
            mapModel1.append({
                "lon": arr[i].lon,
                "lat": arr[i].lat,
                "name": arr[i].name,
                "status": arr[i].status
            })
        }
    }

    Component{
        id: itemsDeligate
        Text {
            text: model.name + " \n   (Широта/Долгота)   " + model.lat + "/" + model.lon + " \n   Статус: " + model.status
        }
    }

	ScrollView {
		anchors.fill: parent

		ListView {
			width: parent.width
            model: mapModel1
//			delegate: ItemDelegate {
//                text: itemsDeligate
//				width: parent.width
//				height: 25
//			}
            delegate: itemsDeligate
            Component.onCompleted: getData1()
		}
	}
}
