#include <QObject>
#include <QtDeclarative/QDeclarativeListProperty>
#include <QList>
#include <QColor>
#include <QObject>
#include <QDebug>
#include <data_transmit.h>
#include <string>
#include <fstream>
#include <ostream>
#include <_nets_cpp.h>
#include <renderthread.h>
using namespace std;
///change data_path to train.prototxt
void Existing_data::click_train_prototxt_path(QString Qdata_path,QString Qtrain_prototxt_file)
{
    qDebug() << "click_train_data_path() called ";
    qDebug() << Qdata_path << " " << Qtrain_prototxt_file;

    update_train_prototxt(Qdata_path.toStdString(),Qtrain_prototxt_file.toStdString());



}
///convert data
void Existing_data::_convertdata(QString Qimageset_path,QString Qlabel_path,QString Qsave_path,QString Qresize_width,QString Qresize_height)
{
    convert_imagedata(Qimageset_path.toStdString(),Qlabel_path.toStdString(),Qsave_path.toStdString(),Qresize_width.toStdString(),Qresize_height.toStdString());
}

///train
void Existing_data::click_train(QString Qsolver_prototxt_file)
{
    Totrain(Qsolver_prototxt_file.toStdString());
}

///test
void Existing_data::click_test(QString Qtest_prototxt_file,QString Qweights_file){
    Totest(Qtest_prototxt_file.toStdString(),Qweights_file.toStdString());
}


///show train.prototxt table
QString Existing_data::_show_train_prototxt(QString Qtrain_prototxt_file)
{
    return QString::fromStdString(show_train_prototxt_table_func(Qtrain_prototxt_file.toStdString())) ;
}
///show batch_size
QString Existing_data::_show_batch_size(QString Qtrain_prototxt_file){
    return QString::fromStdString(show_batch_size_func(Qtrain_prototxt_file.toStdString())) ;
}
///show data_path
QString Existing_data::_show_data_path(QString Qtrain_prototxt_file)
{
    return QString::fromStdString(show_data_path_func(Qtrain_prototxt_file.toStdString())) ;
}
///show layer_size
QString Existing_data::_show_layer_size(QString Qtrain_prototxt_file){

    return QString::fromStdString(show_layer_size_func(Qtrain_prototxt_file.toStdString())) ;
}
///update batch_size
void Existing_data::click_update_batch_size(QString Qtrain_prototxt_file, QString QBatch_size)
{
    update_batch_size_func(Qtrain_prototxt_file.toStdString(),QBatch_size.toStdString());
}

///show solver.prototxt
QString Existing_data::click_solver_prototxt_path(QString Qtrain_prototxt_file, QString Qsolver_prototxt_file)
{
     return QString::fromStdString(update_solver_prototxt(Qtrain_prototxt_file.toStdString(), Qsolver_prototxt_file.toStdString()));

    //return QString::fromStdString(path);//
}
///save solver.prototxt
void Existing_data::click_save_sovler_prototxt(QString Qsolver_prototxt_file,QString Qsovler_prototxt)
{
    click_save_sovler_prototxt_func(Qsolver_prototxt_file.toStdString(), Qsovler_prototxt.toStdString());
}

///new thread to train
void Existing_data::_thread_train(QString solver_prototxt_file)
{
    RenderThread * test_thread = new RenderThread();
    test_thread->train_or_test = 1;//1 == train
    test_thread->Qsolver_prototxt_file = solver_prototxt_file;
    //Existing_data _data;
    //QObject::connect(test_thread, SIGNAL(valueChanged(int)), &_data, SLOT(thread_compute(int)));
    test_thread->start();
    //test_thread->valueChanged(0);
}

///new thread to test
void Existing_data::_thread_test(QString Qtest_prototxt_file,QString Qweights_file)
{
    RenderThread * test_thread = new RenderThread();
    test_thread->train_or_test = 0;//0 == train
    test_thread->Qtest_prototxt_file = Qtest_prototxt_file;
    test_thread->Qweights_file = Qweights_file;
    test_thread->start();
}
