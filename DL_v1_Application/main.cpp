///add 2016/05/31

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QtQml>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <data_transmit.h>
#include <_nets_cpp.h>

#include <QDebug>
#include <QLabel>
#include <renderthread.h>
using namespace std;
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<Existing_data>("Existing_data", 1, 0, "Existing_data");
    QQmlApplicationEngine engine;
    //engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    //convert to qml
    QQmlComponent component(&engine, QUrl(QStringLiteral("qrc:///main.qml")));
    QObject *mainobject = component.create();
    QObject *solver_parameter = mainobject->findChild<QObject*>("_solver_prototxt");

//******************************************************************************************//







  //***************************************************************************************//

    //solver_parameter->setProperty("text",Qline);

    /*
    ///add 2016/05/31
    QVariant msg = "Hello from C++";
    QVariant returnedValue;
    QMetaObject::invokeMethod(mainobject, "myQmlFunction",
            Q_RETURN_ARG(QVariant, returnedValue),
            Q_ARG(QVariant, msg));;
    qDebug() << "QML function returned:" << returnedValue.toString();
    //delete mainobject;
    /**/

    //qml 调用c++函数
   // QQuickView view;
   // Existing_data existing_data;
   // view.rootContext()->setContextProperty("existing_data",&existing_data);
    //view.setSource(QUrl(QStringLiteral("qrc:///main.qml")));
    return app.exec();
}
