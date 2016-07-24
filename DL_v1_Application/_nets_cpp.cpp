#include <QCoreApplication>
#include <caffe/caffe.hpp>
#include <cuda_runtime.h>
#include <fstream>
#include <iostream>
#include <iomanip>
#include <cstring>
#include <string>
#include <cstdlib>
#include <algorithm>
#include <vector>
#include <utility>
#include "caffe/caffe.hpp"
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/highgui/highgui_c.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <QMainWindow>
using namespace cv;
using namespace std;
using namespace caffe;
using std::string;

// caffe.cpp
#include <gflags/gflags.h>
#include <glog/logging.h>

#include <cstring>
#include <map>
#include <string>
#include <vector>
#include <iomanip>
#include "boost/algorithm/string.hpp"
#include "caffe/caffe.hpp"
#include "caffe/util/signal_handler.h"
#include "caffe/layers/data_layer.hpp"
//slover
#include "caffe/net.hpp"
#include "caffe/solver_factory.hpp"
#include "caffe/solver.hpp"

//proto
//#include "caffe/"
#include "caffe/util/io.hpp"
#include "google/protobuf/message.h"

//#include "caffe/common.hpp"
#include "caffe/proto/caffe.pb.h"
#include <string>
#include <_nets_cpp.h>
#include <stdlib.h>
using caffe::Blob;
using caffe::Caffe;
using caffe::Net;
using caffe::Layer;
using caffe::Solver;
using caffe::shared_ptr;
using caffe::string;
using caffe::Timer;
using caffe::vector;
using std::ostringstream;

DEFINE_string(gpu, "",
    "Optional; run in GPU mode on given device IDs separated by ','."
    "Use '-gpu all' to run on all available GPUs. The effective training "
    "batch size is multiplied by the number of devices.");
DEFINE_string(solver, "",
    "The solver definition protocol buffer text file.");
DEFINE_string(model, "",
    "The model definition protocol buffer text file.");
DEFINE_string(snapshot, "",
    "Optional; the snapshot solver state to resume training.");
DEFINE_string(weights, "",
    "Optional; the pretrained weights to initialize finetuning, "
    "separated by ','. Cannot be set simultaneously with snapshot.");
DEFINE_int32(iterations, 50,
    "The number of iterations to run.");
DEFINE_string(sigint_effect, "stop",
             "Optional; action to take when a SIGINT signal is received: "
              "snapshot, stop or none.");
DEFINE_string(sighup_effect, "snapshot",
             "Optional; action to take when a SIGHUP signal is received: "
             "snapshot, stop or none.");
/// update train.prototxt
void update_train_prototxt(string data_path,string train_prototxt_file)
{
    NetParameter train_net_param;
    ReadNetParamsFromTextFileOrDie(train_prototxt_file,&train_net_param);
    //update prototxt
    NetParameter *new_net;
    new_net=&train_net_param;
    LayerParameter layer_net = train_net_param.layer(0);
    DataParameter data_net;
    data_net = train_net_param.layer(0).data_param();
    //if(layer_net.phase() == TRAIN);//
    data_net.set_source(data_path);
    layer_net.mutable_data_param()->Swap(&data_net);
    new_net->mutable_layer(0)->Swap(&layer_net);
    WriteProtoToTextFile(*new_net,train_prototxt_file);

}

/// update batch_size
void update_batch_size_func(string train_prototxt_file,string Batch_size )
{
    NetParameter train_net_param;
    ReadNetParamsFromTextFileOrDie(train_prototxt_file,&train_net_param);
    //update prototxt
    NetParameter *new_net;
    new_net=&train_net_param;
    LayerParameter layer_net = train_net_param.layer(0);
    DataParameter data_net;
    data_net = train_net_param.layer(0).data_param();
    data_net.set_batch_size(std::atoi(Batch_size.data()));
    layer_net.mutable_data_param()->Swap(&data_net);
    new_net->mutable_layer(0)->Swap(&layer_net);
    WriteProtoToTextFile(*new_net,train_prototxt_file);
}

///show train_prototxt details

//read conv_layer kernel_size
void conv_kernel_size(const ConvolutionParameter *conv_param,string &output)
{
    output.append("\t\t");
    stringstream ss;
    ss << conv_param->kernel_size(0);
    output = output + ss.str() + "*" + ss.str();
}
//show layer_size
string show_layer_size_func(string train_prototxt_file)
{
    NetParameter net_param;
    ReadNetParamsFromTextFileOrDie(train_prototxt_file,&net_param);
    stringstream ss;
    ss << net_param.layer_size();
    return ss.str();
}

//show batch_size
string show_batch_size_func(string train_prototxt_file)
{
    NetParameter net_param;
    ReadNetParamsFromTextFileOrDie(train_prototxt_file,&net_param);
    stringstream ss;
    ss << net_param.layer(0).data_param().batch_size();
    return ss.str();
}

//show data_path
string show_data_path_func(string train_prototxt_file)
{
    NetParameter net_param;
    ReadNetParamsFromTextFileOrDie(train_prototxt_file,&net_param);
    stringstream ss;
    ss << net_param.layer(0).data_param().source();
    return ss.str();
}

//show train.prototxt table
string show_train_prototxt_table_func(string train_prototxt_file){
    string output;
    NetParameter net_param;
    ReadNetParamsFromTextFileOrDie(train_prototxt_file,&net_param);
    output = "Name\t\t\tType\t\t              kernel_size\t                num\n";
    for(int i = 0;i<net_param.layer_size();i++)
    {
        output += net_param.layer(i).name() ;

        if(net_param.layer(i).name().length()>8)
            output = output + "\t\t" + net_param.layer(i).type();
        else
            output = output + "\t\t\t" + net_param.layer(i).type();
        if(!strcmp(net_param.layer(i).type().data(),"Convolution"))
        {

            conv_kernel_size(&net_param.layer(i).convolution_param(),output);
            output = output + "\t\t" ;

            stringstream ss;
            ss << net_param.layer(i).convolution_param().num_output();
            output += ss.str();
        }
        else if(!strcmp(net_param.layer(i).type().data(),"Pooling"))
        {
           output = output + "\t\t\t" ;
           stringstream ss;
           ss << net_param.layer(i).pooling_param().kernel_size();
           output = output + ss.str() + "*" + ss.str();
        }
        else{
            output = output + "\t\t";
        }

        output = output + "\n";

    }
    return output;
}

/// update solver.prototxt Only train.prototxt
string update_solver_prototxt(string train_prototxt_file, string solver_prototxt_file)
{
    SolverParameter solver;
    ReadSolverParamsFromTextFileOrDie(solver_prototxt_file,&solver);
    //update it
    solver.set_train_net(train_prototxt_file);
    WriteProtoToTextFile(solver,solver_prototxt_file);
    //read the solver.prototxt
    ifstream in(solver_prototxt_file.data());
    string line;
    string all_line;
    if(in) // get the file
    {
        while (getline (in, line)) // should add \n
        {
            all_line += line;
            all_line.append("\r\n");
        }
    }
    else // get no file
    {
        all_line = "no such file";
    }
    return all_line;


}

/// save solver.prototxt all
void click_save_sovler_prototxt_func(string solver_prototxt_file,string solver_protxotx){
    FILE *fpr = fopen(solver_prototxt_file.data(),"w+");
    fprintf(fpr,solver_protxotx.data());
    fclose(fpr);

}







///train
// Parse GPU ids or use all available devices
static void get_gpus(vector<int>* gpus) {
      if (FLAGS_gpu == "all") {
        int count = 0;
    #ifndef CPU_ONLY
        CUDA_CHECK(cudaGetDeviceCount(&count));
    #else
        NO_GPU;
    #endif
        for (int i = 0; i < count; ++i) {
          gpus->push_back(i);
        }
      } else if (FLAGS_gpu.size()) {
        vector<string> strings;
        boost::split(strings, FLAGS_gpu, boost::is_any_of(","));
        for (int i = 0; i < strings.size(); ++i) {
          gpus->push_back(boost::lexical_cast<int>(strings[i]));
        }
      } else {
        CHECK_EQ(gpus->size(), 0);
      }
}

// Load the weights from the specified caffemodel(s) into the train and
// test nets.
void CopyLayers(caffe::Solver<float>* solver, const std::string& model_list) {
      std::vector<std::string> model_names;
      boost::split(model_names, model_list, boost::is_any_of(",") );
      for (int i = 0; i < model_names.size(); ++i) {
        LOG(INFO) << "Finetuning from " << model_names[i];
        solver->net()->CopyTrainedLayersFrom(model_names[i]);
        for (int j = 0; j < solver->test_nets().size(); ++j) {
          solver->test_nets()[j]->CopyTrainedLayersFrom(model_names[i]);
        }
      }
}

caffe::SolverAction::Enum GetRequestedAction(
        const std::string& flag_value) {
      if (flag_value == "stop") {
            return caffe::SolverAction::STOP;
      }
      if (flag_value == "snapshot") {
            return caffe::SolverAction::SNAPSHOT;
      }
      if (flag_value == "none") {
            return caffe::SolverAction::NONE;
      }
      LOG(FATAL) << "Invalid signal effect \""<< flag_value << "\" was specified";
}

void Totrain(const string slover_file ) {

    if(slover_file.length() == 0)
        LOG(INFO) << "Please Choose solver.prototxt";
    caffe::SolverParameter solver_param;
    caffe::ReadSolverParamsFromTextFileOrDie(slover_file, &solver_param);

    Caffe::SetDevice(0);
    Caffe::set_mode(Caffe::GPU);
    caffe::SignalHandler signal_handler(
          GetRequestedAction(FLAGS_sigint_effect),
          GetRequestedAction(FLAGS_sighup_effect));

    shared_ptr<caffe::Solver<float> >
        solver(caffe::SolverRegistry<float>::CreateSolver(solver_param));

    solver->SetActionFunction(signal_handler.GetActionFunction());

    LOG(INFO) << "Starting Optimization";
    solver->Solve();
    LOG(INFO) << "Optimization Done.";

}

///test

void Totest(string test_prorotxt_file,string weights_file)
{


    // Set device id and mode
    vector<int> gpus;
    get_gpus(&gpus);
    if (gpus.size() != 0) {
      LOG(INFO) << "Use GPU with device ID " << gpus[0];
  #ifndef CPU_ONLY
      cudaDeviceProp device_prop;
      cudaGetDeviceProperties(&device_prop, gpus[0]);
      LOG(INFO) << "GPU device name: " << device_prop.name;
  #endif
      Caffe::SetDevice(gpus[0]);
      Caffe::set_mode(Caffe::GPU);
    } else {
      LOG(INFO) << "Use CPU.";
      Caffe::set_mode(Caffe::CPU);
    }
    // Instantiate the caffe net.
    NetParameter test_net_param;
    ReadProtoFromTextFile(test_prorotxt_file, &test_net_param);
    Net<float> caffe_net(test_net_param);
    NetParameter trained_net_param;
    ReadProtoFromBinaryFile(weights_file, &trained_net_param);
    caffe_net.CopyTrainedLayersFrom(trained_net_param);
    LOG(INFO) << "Running for " << FLAGS_iterations << " iterations.";

    vector<int> test_score_output_id;
    vector<float> test_score;
    float loss = 0;
    for (int i = 0; i < FLAGS_iterations; ++i) {
      float iter_loss;
      const vector<Blob<float>*>& result =
          caffe_net.Forward(&iter_loss);
      loss += iter_loss;
      int idx = 0;
      for (int j = 0; j < result.size(); ++j) {
        const float* result_vec = result[j]->cpu_data();
        for (int k = 0; k < result[j]->count(); ++k, ++idx) {
          const float score = result_vec[k];
          if (i == 0) {
            test_score.push_back(score);
            test_score_output_id.push_back(j);
          } else {
            test_score[idx] += score;
          }
          const std::string& output_name = caffe_net.blob_names()[
              caffe_net.output_blob_indices()[j]];
          LOG(INFO) << "Batch " << i << ", " << output_name << " = " << score;
        }
      }
    }
    loss /= FLAGS_iterations;
    LOG(INFO) << "Loss: " << loss;
    for (int i = 0; i < test_score.size(); ++i) {
      const std::string& output_name = caffe_net.blob_names()[
          caffe_net.output_blob_indices()[test_score_output_id[i]]];
      const float loss_weight = caffe_net.blob_loss_weights()[
          caffe_net.output_blob_indices()[test_score_output_id[i]]];
      std::ostringstream loss_msg_stream;
      const float mean_score = test_score[i] / FLAGS_iterations;
      if (loss_weight) {
        loss_msg_stream << " (* " << loss_weight
                        << " = " << loss_weight * mean_score << " loss)";
      }
      LOG(INFO) << output_name << " = " << mean_score << loss_msg_stream.str();
    }

}
///convert data
void convert_imagedata(string imageset_path, string label_path, string save_path, string resize_width, string resize_height)
{
    string shell_cmd = "GLOG_logtostderr=1 $CAFFE_ROOT/build/tools/convert_imageset ";
    //resize
    shell_cmd =shell_cmd + "--resize_height=" + resize_height + " ";
    shell_cmd =shell_cmd + "--resize_width=" + resize_width + " ";
    //shuffle
    shell_cmd += "--shuffle ";
    shell_cmd += imageset_path + " " + label_path + " " + save_path;
    system(shell_cmd.data());
}
