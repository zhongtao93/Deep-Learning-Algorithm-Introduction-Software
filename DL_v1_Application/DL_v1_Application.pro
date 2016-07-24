TEMPLATE = app

QT += qml quick core gui widgets
QT -= gui

SOURCES += main.cpp \
    data_transmit.cpp \
    _nets_cpp.cpp \
    renderthread.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    data_transmit.h \
    _nets_cpp.h \
    renderthread.h

# adding dynamic links of CAFFE and its dependencies


INCLUDEPATH += /usr/local/include \
                /usr/local/include/opencv \
                /usr/local/include/opencv2

LIBS += /usr/local/lib/libopencv_highgui.so \
        /usr/local/lib/libopencv_core.so    \
        /usr/local/lib/libopencv_imgproc.so \
        /usr/local/lib/libopencv_imgcodecs.so


# adding dynamic links of CAFFE and its dependencies

# caffe
INCLUDEPATH += /home/zhongtao/caffe-master/include  /home/zhongtao/caffe-master/build/src
LIBS += -L/home/zhongtao/caffe-master/build/lib
LIBS += -lcaffe

#cuda
INCLUDEPATH += /usr/local/cuda/include
LIBS += -L/usr/local/cuda/lib64
LIBS += -lcudart -lcublas -lcurand

# other dependencies
LIBS += -lglog -lgflags -lprotobuf -lboost_system -lboost_thread -llmdb -lleveldb -lstdc++ -lcudnn -lcblas -latlas

DISTFILES +=
