import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1
import Existing_data 1.0

Window {
    id: covert_windows
    width:500; height: 300
    color: '#CCCCCC'

    Label {
        id: label1
        x: 11
        y: 70
        width: 37
        height: 19
        text: qsTr("Imageset:")
    }

    Text {
        id: imageset_path
        x: 79
        y: 70
        width: 419
        height: 19
        text: qsTr("Text")
        font.pixelSize: 12
    }

    Label {
        id: label2
        x: 11
        y: 95
        width: 62
        height: 19
        text: qsTr("Label:")
    }

    Text {
        id: label_path
        x: 79
        y: 95
        width: 419
        height: 19
        text: qsTr("Text")
        font.pixelSize: 12
    }

    Label {
        id: label3
        x: 11
        y: 120
        width: 62
        height: 19
        text: qsTr("LMDB:")
    }

    Text {
        id: lmdb_path
        x: 79
        y: 120
        width: 419
        height: 19
        text: qsTr("Text")
        font.pixelSize: 12
    }

    Label {
        id: label4
        x: 6
        y: 14
        text: qsTr("Convert Data:")
        font.pointSize: 16
    }

    Label {
        id: label5
        x: 8
        y: 154
        text: qsTr("Resize")
    }

    Label {
        id: label6
        x: 11
        y: 47
        text: qsTr("Path")
    }

    Label {
        id: label7
        x: 11
        y: 187
        text: qsTr("Width:")
    }

    TextEdit {
        id: resize_width
        x: 65
        y: 187
        width: 49
        height: 20
        text: qsTr("Text Edit")
        font.pixelSize: 12
    }

    Label {
        id: label8
        x: 115
        y: 188
        text: qsTr("0 means no resize")
    }

    Label {
        id: label9
        x: 11
        y: 210
        text: qsTr("Height:")
    }

    TextEdit {
        id: resize_height
        x: 65
        y: 210
        width: 49
        height: 20
        text: qsTr("Text Edit")
        font.pixelSize: 12
    }

    Label {
        id: label10
        x: 116
        y: 210
        text: qsTr("0 means no resize")
    }

    ToolButton {
        id: toolButton1
        x: 206
        y: 246
        width: 88
        height: 30
        text: "convert"
    }
}

