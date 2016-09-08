#!/bin/sh

cd=`pwd`

#first clone the repository
git clone https://github.com/statgen/gotcloud.git

sed -i s/-static//g  gotcloud/src/mosaik/src/includes/linux.inc


source /com/extra/gcc/5.2.0/load.sh
source /com/extra/zlib/1.2.8/load.sh
source /com/extra/cmake/3.3.2/load.sh

cd $cd/gotcloud/src/

make opt -j4
make -j4

cd $cd/gotcloud
sed -i '1194s/ln/cp/' $cd/gotcloud/bin/align.pl

wget ftp://anonymous@share.sph.umich.edu/gotcloud/ref/hs37d5-db142-v1.tgz
tar xzf hs37d5-db142-v1.tgz
rm -f hs37d5-db142-v1.tgz
