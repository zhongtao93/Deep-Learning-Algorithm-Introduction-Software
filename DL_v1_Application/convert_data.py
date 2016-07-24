#coding=utf-8
import os
rootdir="/home/zhongtao/QT_code/DL_v1/data/images/imageNet/test"
#存在test的图片目录
file=open('/home/zhongtao/QT_code/DL_v1/data/images/test_label.txt','w')
#保存在test_label.txt中
x=-1
for parent,dirnames,filenames in os.walk(rootdir):
    for dirname in filenames:
     #   list=os.path.split(dirname)
        list=os.path.split(parent)[-1]#split把一个路径拆分为两部分，后一部分总是最后级别的目录或文件名
        file.write(list + "/"+  dirname)
        file.write(' '+"%d"%x)
        file.write('\n')
    x=x+1;
file.close()
#convert to lmdb
RESIZE = 1
if RESIZE: #resize 256*256
    os.system('GLOG_logtostderr=1 $CAFFE_ROOT/build/tools/convert_imageset --resize_height=227 --resize_width=227 --shuffle $DL_v1/data/images/imageNet/test/ $DL_v1/data/images/test_label.txt $DL_v1/data/lmdb/test_imageNet_lmdb')
else:      #not resize
    os.system('GLOG_logtostderr=1 $CAFFE_ROOT/build/tools/convert_imageset --resize_height=0 --resize_width=0 --shuffle $DL_v1/data/test/ $DL_v1/data/test_label.txt $DL_v1/data/lmdb/test_imageNet_lmdb')
print "Done"
