#ifndef CREATE_TREAD
#define CREATE_TREAD
#include <QThread>

//================================================================
class Worker : public QObject
{
    Q_OBJECT

public slots:
    void doWork(const QString &parameter) {
        QString result;
        /* ... here is the expensive or blocking operation ... */
        emit resultReady(result);
    }

signals:
    void resultReady(const QString &result);
};


#endif // CREATE_TREAD

