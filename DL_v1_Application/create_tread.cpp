//文件名称：create_thread.h

//文件描述：实例化线程子类

//注意事项：
#include <iostream>
#include <create_tread.h>
#include <_nets_cpp.h>
//===========================================================
Thread :: Thread()
{
    stopped = false;
}
//=============================================================
void Thread :: run()
{
    string solver_prototxt_file = "/home/zhongtao/QT_code/DL_v1_Application/models/Lenet/solver.prototxt";
    Totrain(solver_prototxt_file);

    stopped = true;
    std::cerr << std::endl;
}
//=============================================================
void Thread::stop()
{
    stopped = true;
}
//=========================================================
void Thread::setMessage(const QString &message)
{
    messageStr = message;
}


