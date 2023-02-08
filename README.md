# base-image
## 镜像构建
先在mpich文件夹中运行 docker build -t zhuhe0321/mpich:v2.0 .

构建成功后在mpirun_base目录下运行 docker build -t zhuhe0321/mpirun_base .

## 镜像介绍
mpich: 代码编译环境，包含完整MPICH和编译指令

mpirun_base: 代码运行环境，仅包含mpirun和基础动态链接