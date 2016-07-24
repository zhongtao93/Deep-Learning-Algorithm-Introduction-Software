#ifndef _NETS_CPP_H
#define _NETS_CPP_H
#include <fstream>
#include <iostream>
#include <iomanip>
#include <cstring>
#include <string>
#include <cstdlib>
#include <algorithm>
#include <vector>
#include <utility>


using namespace std;
///update train.prototxt
void update_train_prototxt(string data_path,string train_prototxt_file);
/// update batch_size
void update_batch_size_func(string train_prototxt_file,string Batch_size );

///show train.prototxt
string show_batch_size_func(string train_prototxt_file);
string show_train_prototxt_table_func(string train_prototxt_file);
string show_data_path_func(string train_prototxt_file);
string show_layer_size_func(string train_prototxt_file);
///update solver.prototxt Only change the train.prototxt source
string update_solver_prototxt(string train_prototxt_file, string solver_prototxt_file);

///update solver.prototxt all
void click_save_sovler_prototxt_func(string solver_prototxt_file,string solver_protxotx);
///train
void Totrain(const string solver_prototxt_file);

///test
void Totest(string test_prorotxt_file,string weights_file);

///convert data
void convert_imagedata(string imageset_path, string label_path, string save_path, string resize_width, string resize_height);

#endif // _NETS_CPP_H

