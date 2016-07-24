#ifndef DATA_TRANSMIT_H
#define DATA_TRANSMIT_H
#include <QObject>
#include <QtDeclarative/QDeclarativeListProperty>
#include <QList>
#include <QColor>
#include <QObject>
#include <QDebug>
#include <renderthread.h>
class Existing_data : public QObject
{
    Q_OBJECT
signals:
    void open_train_prototxt();
    QString open_solver_prototxt();
    void train();
    QString show_train_prototxt();
    QString show_batch_size();
    QString show_data_path();
    QString show_layer_size();
    void update_batch_size();
    void save_solver_prototxt();
    void test();
    void convertdata();
    void thread_train();
    void thread_test();

public slots:
    void click_train_prototxt_path(QString Qdata_path,QString Qtrain_prototxt_file);
    QString click_solver_prototxt_path(QString Qtrain_prototxt_file, QString Qsolver_prototxt_file);
    void click_train(QString Qsolver_prototxt_file);
    QString _show_train_prototxt(QString Qtrain_prototxt_file);
    QString _show_batch_size(QString Qtrain_prototxt_file);
    QString _show_data_path(QString Qtrain_prototxt_file);
    QString _show_layer_size(QString Qtrain_prototxt_file);
    void click_update_batch_size(QString Qtrain_prototxt_file, QString QBatch_size);
    void click_save_sovler_prototxt(QString Qsolver_prototxt_file,QString Qsovler_prototxt);
    void click_test(QString Qtest_prototxt_file,QString Qweights_file);
    void _convertdata(QString Qimageset_path,QString Qlabel_path,QString Qsave_path,QString Qresize_width,QString Qresize_height);
    //new thread
    void _thread_train(QString solver_prototxt_file);
    void _thread_test(QString Qtest_prototxt_file,QString Qweights_file);


public:
        RenderThread thread;


};
#endif // DATA_TRANSMIT_H
