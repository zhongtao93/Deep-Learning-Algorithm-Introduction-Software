import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1
import Existing_data 1.0
ApplicationWindow {
    title: "DNN Learning Software";
    id:_main
    width: 800;
    height: 500;
    x:400;
    y:200;
    visible: true;
    //Global Variables
    property string data_path
    property string train_prototxt_file
    property string solver_prototxt_file
    property string test_prototxt_file
    property string weights_file
    property string imageset_path
    property string label_path
    property string lmdb_save_path
    property string resize_width: "0"
    property string resize_height: "0"

    //thread .js still not work
    WorkerScript {
        id: myWorker
        source: "train_or_test.js"

        onMessage: console.log( messageObject.reply)
    }

    MessageDialog{
        id:_target_train
        text: "You plan to Train"
        onAccepted: {
            _target_train.close();
        }
    }
    MessageDialog{
        id:_target_test
        text: "You plan to Test"
        onAccepted: {
            _target_test.close();
        }
    }


    Window {
        id: convert_windows
        width:550; height: 300
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
            id: imageset_path_text
            x: 79
            y: 70
            width: 419
            height: 19
            text: imageset_path
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
            id: label_path_text
            x: 79
            y: 95
            width: 419
            height: 19
            text: label_path
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
            id: lmdb_path_text
            x: 79
            y: 120
            width: 419
            height: 19
            text: lmdb_save_path
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
            id: resize_width_text
            x: 65
            y: 187
            width: 49
            height: 20
            text: resize_width
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
            id: resize_height_text
            x: 65
            y: 210
            width: 49
            height: 20
            text: resize_height
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
            onClicked: {
                existing_data_cpp.onConvertdata();
                convert_over.open();
            }
        }
    }

    MessageDialog{
        id:convert_over
        text:"Convert Completed!"
        onAccepted: {
            convert_over.close();
            convert_windows.close();
        }
    }
    //MenuBar
    menuBar:MenuBar {

        Menu{
            title: "Target"
            MenuItem{
                text: "Train"
                onTriggered: {
                    _target_train.open();
                    _train_prototxt_menu.enabled = true;
                    _solver_prototxt_menu.enabled = true;
                    _train_menu.enabled = true;
                    _weights_file_menu.enabled = false;
                    _test_prototxt_menu.enabled = false;
                    _test_menu.enabled = false;
                }
            }
            MenuItem{
                text: "Test"
                onTriggered: {
                    _target_test.open();
                    _train_menu.enabled = false;
                    _train_prototxt_menu.enabled = false;
                    _solver_prototxt_menu.enabled = false;
                    _weights_file_menu.enabled = true;
                    _test_prototxt_menu.enabled = true;
                    _test_menu.enabled = true;
                }
            }
        }

        Menu {
            title: "Data"
            MenuItem {
                text: "Open Existing Data"
                onTriggered: {
                    existingdata_fileDialog.open();
                }
            }
            Menu {
                title: "Convert Your Data"

                MenuItem {
                    text: "Choose Imageset Folder"
                    onTriggered: {
                        imageset_fileDialog.open()
                    }
                }
                MenuItem {
                    text: "Choose Label File"
                    onTriggered: {
                        label_fileDialog.open()
                    }

                }
                MenuItem{
                    text: "Choose Lmdb Save Folder"
                    onTriggered: {
                        lmdb_save_fileDialog.open()
                    }
                }

                MenuItem {
                    text: "Convert"
                    onTriggered: {
                        convert_windows.show()
                    }
            }
        }
    }
        Menu {
            title: "Nets"
            MenuItem {
                text: "Train prototxt"
                id: _train_prototxt_menu
                onTriggered: {
                    existing_Nets_Dialog.open();
                    //update page
                    _Interface.visible = false;
                    _Main_page.visible = true;
                    _Main_Interface.visible = true;
                    _Datasets.visible = false;
                    _Nets.visible = true;
                    _Custom_parameter.visible = false;
                    _Train.visible = false;
                    _nets_title.text = "train.prototxt parameter"
                }
            }
            MenuItem {
                text: "Solver prototxt"
                id: _solver_prototxt_menu
                onTriggered: {
                    existing_solver_Dialog.open();
                    //update page

                    _Interface.visible = false;
                    _Main_page.visible = true;
                    _Main_Interface.visible = true;
                    _Datasets.visible = false;
                    _Nets.visible = false;
                    _Custom_parameter.visible = true;
                    _Train.visible = false;


                }

            }
            MenuItem {
                text: "Test prototxt"
                id: _test_prototxt_menu
                onTriggered: {
                    existing_Test_nets_Dialog.open();
                    //update page
                    _Interface.visible = false;
                    _Main_page.visible = true;
                    _Main_Interface.visible = true;
                    _Datasets.visible = false;
                    _Nets.visible = true;
                    _Custom_parameter.visible = false;
                    _Train.visible = false;
                    _nets_title.text = "test.prototxt parameter"
                }
            }
            MenuItem{
                text: "Weights file"
                id: _weights_file_menu
                onTriggered: {
                    pretrained_weights_fileDialog.open();
                }
            }
        }


        Menu{
            title: "Train/Test"
            MenuItem{
                id:_train_menu
                text: "Train";
                onTriggered:
                {
                    _Interface.visible = false;
                    _Main_page.visible = true;
                    _Main_Interface.visible = true;
                    _Datasets.visible = false;
                    _Nets.visible = false;
                    _Custom_parameter.visible = false;
                    _Train.visible = true;

                    _train_or_test_status.text = "Train..."

                    //beging to train
                    //existing_data_cpp.onTrain();
                    //end
                   //myWorker.sendMessage(solver_prototxt_file);
                    existing_data_cpp.onThread_train();
                    //_train_over.open();
                }
            }
            MenuItem{
                id:_test_menu
                text: "Test";
                onTriggered: {
                    _Main_page.visible = true;
                    _Main_Interface.visible = true;
                    _Datasets.visible = false;
                    _Nets.visible = false;
                    _Custom_parameter.visible = false;
                    _Train.visible = true;

                    _train_or_test_status.text = "Test..."
                    //begin to test
                    existing_data_cpp.onThread_test();
                    //end
                   //_test_over.open()
                }
            }
        }
        Menu{
            title: "Help"
        }
    }

    //Interface
    Rectangle{
        id:_Interface
        x: _main.width / 5;
        width: _main.width; height: _main.height;
        anchors.fill: parent
        Image{
              width: _Interface.width; height: _Interface.height;
              //fillMode: Image.Tile
              source: "Resources_imgs/deep-learning-pic-768x495.png"
              //sourceSize.width: 1896;sourceSize.height: 1139;
              z:1;
        }
        Text{
            x: 376
            y: 148
            width: 339
            height: 101
            color:"white"
            text:"Deep Neural Networks \n Learning Software";
            font.family: "Helvetica";
            font.pointSize: _main.width / 28
            font.bold: true;
            //anchors.horizontalCenterOffset: 200
            z:2
        }
     }


    //Main Interface
    RowLayout{
            id: _Main_Interface
            visible: false
            anchors.fill: parent
            spacing: 0
  Rectangle{
                id: _Main_page
                Layout.fillWidth: true;Layout.fillHeight: true;
                Layout.minimumWidth: 50
                //Step 1 Datasets
                Rectangle{
                    id: _Datasets
                    color: "#00bfff"
                    anchors.centerIn: parent
                    width: _Main_page.width; height: _Main_page.height;
                    /***************************** option 1 ***************************************/
                    //open existing data dialog
                    FileDialog{
                        id: existingdata_fileDialog
                        title: "Please choose existing datasets root folder"
                        width: 200;height: 100;
                        visible: false
                        selectFolder: true
                        folder:  "file:///home/zhongtao/QT_code/DL_v1_Application/data"
                        onAccepted: {
                        }
                        onRejected: {
                            existingdata_fileDialog.close()
                        }
                    }
                    /**/
                    //cpp function
                    Existing_data{
                        id: existing_data_cpp
                        //take a cpp function

                        onOpen_train_prototxt: click_train_prototxt_path(data_path,train_prototxt_file);
                        onOpen_solver_prototxt: show_slover_txt.text = click_solver_prototxt_path(train_prototxt_file,solver_prototxt_file);
                        //onTrain: click_train(solver_prototxt_file);
                        //onTest: click_test(test_prototxt_file,weights_file);
                        /**/
                        onShow_train_prototxt: show_train_prototxt.text = _show_train_prototxt(train_prototxt_file);
                        onShow_batch_size:  show_batch_size.text = _show_batch_size(train_prototxt_file);
                        onShow_data_path: show_data_path.text = _show_data_path(train_prototxt_file);
                        onShow_layer_size: show_layer_size.text = _show_layer_size(train_prototxt_file);
                        onUpdate_batch_size: click_update_batch_size(train_prototxt_file,show_batch_size.text);
                        onSave_solver_prototxt: click_save_sovler_prototxt(solver_prototxt_file,show_slover_txt.text);
                        onConvertdata: _convertdata(imageset_path,label_path,lmdb_save_path,resize_width,resize_height);
                        onThread_train: _thread_train(solver_prototxt_file);
                        onThread_test: _thread_test(test_prototxt_file,weights_file);
                        /**/
                    }


                    /************************* option 2 **********************************/
                    //open images data dialog
                    FileDialog{
                        id: imageset_fileDialog
                        title: "Please choose your images root folder"
                        visible: false
                        selectFolder: true
                        folder:  "file:///home/zhongtao/QT_code/DL_v1_Application/data"
                        onAccepted: {
                            imageset_path = imageset_fileDialog.fileUrl.toString().replace("file://","") + "/";
                        }
                        onRejected: {
                            imagedata_fileDialog.close()
                        }
                    }
                    // choose label file dialog
                    FileDialog{
                        id: label_fileDialog
                        title: "Please choose your label file"
                        visible: false
                        folder:  "file:///home/zhongtao/QT_code/DL_v1_Application/data"
                        nameFilters: "*.txt"
                        onAccepted: {
                            label_path = label_fileDialog.fileUrl.toString().replace("file://","");
                        }
                        onRejected: {
                            label_fileDialog.close()
                        }
                    }
                    //choose lmdb save path
                    FileDialog{
                        id: lmdb_save_fileDialog
                        title: "Please choose your lmdb save path"
                        visible: false
                        selectFolder: true
                        folder:  "file:///home/zhongtao/QT_code/DL_v1_Application/data"
                        onAccepted: {
                            lmdb_save_path = lmdb_save_fileDialog.fileUrl.toString().replace("file://","") + "/lmdb_data";
                        }
                        onRejected: {
                            lmdb_save_fileDialog.close()
                        }
                    }

                    Text{
                        x: 133
                        y: 95
                        text: "Selected Data";
                        font.pixelSize: 40;
                    }

                    TextArea{
                        id: data_details
                        width: _Datasets.width *2/3
                        height: _Datasets.height / 2
                        x: _Datasets.width/6
                        y: _Datasets.height * 1/3
                        textColor: "#3d3d3d"
                    }
                }
                //Step 2 Nets
                Rectangle{
                    id: _Nets
                    visible: false
                    color: "#CCCCCC"
                    anchors.centerIn: parent
                    width: _Main_page.width; height: _Main_page.height;
                    Text{
                        id: _nets_title
                        x: 28
                        y: 27
                        text: "train.prototxt parameter"
                        font.pixelSize: 25
                    }
                    Label{
                        x: 28
                        y: 71
                        text:"Batch_Size:"
                        font.pixelSize: 20
                    }
                    TextEdit{
                        id:show_batch_size
                        x: 135
                        y: 71
                        width: 51
                        height: 23

                        text:"error"
                        font.pixelSize: 20
                    }
                    Label{
                        x: 28
                        y: 106
                        text:"Data_Path:"
                        font.pixelSize: 20
                    }
                    Text{
                        id:show_data_path
                        x: 130
                        y: 110
                        width: 477
                        height: 17
                        focus: true
                        text:"error"

                    }
                    //show layer_size
                    Label{
                        x: 319
                        y: 71
                        text:"layer_size:"
                        font.pixelSize: 20
                    }
                    Text{
                        id:show_layer_size
                        x: 416
                        y: 71
                        width: 46
                        height: 23

                        text:"error"
                        font.pixelSize: 20
                    }

                    //show prototxt
                    TextArea{
                        id: show_train_prototxt
                        width: _Datasets.width -10
                        height: _Datasets.height *2/3
                        x: 5
                        y: _Datasets.height /3.2
                        textColor: "#3d3d3d"
                        text:"error"
                        font.pixelSize: 18
                        activeFocusOnPress: false
                    }


                    //choose existing train nets
                    FileDialog{
                        id: existing_Nets_Dialog
                        title: "Please choose your train.prototxt"
                        visible: false
                        selectFolder: false //choose a file
                        nameFilters: "*.prototxt"
                        folder:  "file:///home/zhongtao/QT_code/DL_v1_Application/models"
                        onAccepted: {
                            //get data_path
                            data_path = existingdata_fileDialog.fileUrl.toString().replace("file://","");

                            train_prototxt_file = existing_Nets_Dialog.fileUrl.toString().replace("file://","")
                            //update train.prototxt
                            existing_data_cpp.onOpen_train_prototxt();
                            // show train.prototxt
                            existing_data_cpp.onShow_train_prototxt();
                            //show batch_size
                            existing_data_cpp.onShow_batch_size();
                            //show data_path
                            existing_data_cpp.onShow_data_path();
                            //show layer_size
                            existing_data_cpp.onShow_layer_size();
                            console.log(existing_data_cpp.onShow_train_prototxt());

                        }
                        onRejected: {
                            existing_Nets_Dialog.close()
                        }
                    }

                    //choose existing solver
                    FileDialog{
                        id: existing_solver_Dialog
                        title: "Please choose your solver.prototxt"
                        visible: false
                        selectFolder: false //choose a file
                        nameFilters: "*.prototxt"
                        folder:  "file:///home/zhongtao/QT_code/DL_v1_Application/models"
                        onAccepted: {
                            //get slover.prototxt path
                            solver_prototxt_file = existing_solver_Dialog.fileUrl.toString().replace("file://","");
                            existing_data_cpp.onOpen_solver_prototxt();

                        }
                        onRejected: {
                            existing_solver_Dialog.close();
                        }
                    }

                    //choose existing train nets
                    FileDialog{
                        id: existing_Test_nets_Dialog
                        title: "Please choose your test.prototxt"
                        visible: false
                        selectFolder: false //choose a file
                        nameFilters: "*.prototxt"
                        folder:  "file:///home/zhongtao/QT_code/DL_v1_Application/models"
                        onAccepted: {
                            //get data_path
                            data_path = existingdata_fileDialog.fileUrl.toString().replace("file://","");
                            train_prototxt_file = existing_Test_nets_Dialog.fileUrl.toString().replace("file://","")
                            test_prototxt_file = existing_Test_nets_Dialog.fileUrl.toString().replace("file://","")
                            //update train.prototxt
                            existing_data_cpp.onOpen_train_prototxt();
                            // show train.prototxt
                            existing_data_cpp.onShow_train_prototxt();
                            //show batch_size
                            existing_data_cpp.onShow_batch_size();
                            //show data_path
                            existing_data_cpp.onShow_data_path();
                            //show layer_size
                            existing_data_cpp.onShow_layer_size();


                        }
                        onRejected: {
                            existing_Nets_Dialog.close()
                        }
                    }
                    MessageDialog{
                        id:_weights_over
                        text: "Successfully!"
                        detailedText: weights_file
                        onAccepted: _weights_over.close()
                    }
                    //choose pretrained weights
                    FileDialog{
                        id: pretrained_weights_fileDialog
                        visible: false
                        title: "Choose pretrained weights"
                        nameFilters: "*.caffemodel"
                        folder:  "file:///home/zhongtao/QT_code/DL_v1_Application/models"
                        onAccepted: {
                            weights_file = pretrained_weights_fileDialog.fileUrl.toString().replace("file://","");
                            console.log(weights_file);
                            _weights_over.open();
                        }
                        onRejected: {
                            pretrained_weights_fileDialog.close();
                        }
                    }
                MessageDialog{
                    id:modify_batch_size_ok
                    text: "Modify Batch_Size Successfully!"
                    onAccepted: {
                        modify_batch_size_ok.close();
                    }
                }
                    Button {
                        id: save_batch_size
                        x: 197
                        y: 69
                        width: 58
                        height: 28
                        text: qsTr("Modify")
                        onClicked: {
                            existing_data_cpp.onUpdate_batch_size();
                            modify_batch_size_ok.open();
                        }
                    }


                }
                //Step 3 Custom parameter
                Rectangle{
                    id: _Custom_parameter
                    visible: false
                    color: "#CCCCCC"
                    anchors.centerIn: parent
                    width: _Main_page.width; height: _Main_page.height;
                    Text{
                        x: 15
                        y: 38
                        text: "Change your Slover Custom parameter here"
                        font.pixelSize: 20
                    }

                    //show solver.prototxt in Text
                    Rectangle{
                       width: _Custom_parameter.width-10;//height: _Custom_parameter.height-70
                        x: 15;y: 83
                        height: 335
                        color: "white"
                        TextEdit{
                            id: show_slover_txt
                            text: "error"
                        }
                    }
                    MessageDialog{
                        id:save_solver_prototxt_ok
                        text: "Save solver.prototxt Successfully!"
                        onAccepted: {
                            save_solver_prototxt_ok.close();
                        }
                    }

                    Button{
                        x: 461
                        y: 30
                        width: 86
                        height: 35
                        text:"Save"
                        onClicked: {
                            //console.log(show_slover_txt.text);
                            existing_data_cpp.onSave_solver_prototxt();
                            save_solver_prototxt_ok.open();
                        }
                    }
                }

                //Step 4 Train/Test
                Rectangle{
                    id: _Train
                    visible: false
                    color: "#CCCCCC"
                    anchors.centerIn: parent
                    width: _Main_page.width; height: _Main_page.height;
                    Image {
                        id: coffee
                        width: _Main_page.width; height: _Main_page.height;
                        fillMode: Image.PreserveAspectFit
                        source: "Resources_imgs/news-and-coffee3.jpg"
                        z:1
                    }
                    Text{
                        id:_train_or_test_status
                        x: 17
                        y: 49
                        width: 216
                        height: 77
                        text: "Training... "
                        z:2
                        font.pixelSize: 25
                    }
                    MessageDialog{
                        id: _train_over
                        text: "Training Completed!!"
                        onAccepted: _train_over.close();
                    }
                    MessageDialog{
                        id: _test_over
                        text: "Testing Completed!!"
                        onAccepted: _test_over.close();
                    }

                }
            }
    }


}
