# ipsych.gotcloud
using gotcloud inside iPSYCH cluster

##Install gotcloud

Note: this will take some time (~15 mins)
```
git clone https://veera_dr@bitbucket.org/veera_dr/ipsych.gotcloud.git

cd ipsych-gotcloud

sh install.sh

```
##prepare the input file list

if you are starting with fastq files, prepare a file similar to the following example 

```
MERGE_NAME	FASTQ1						FASTQ2					RGID 	SAMPLE		LIBRARY	CENTER	PLATFORM 
Sample1		fastq/S1/F1_R1.fastq.gz		fastq/S1/F1_R2.fastq.gz	RGID1	SampleID1	Lib1	UM		ILLUMINA 
Sample1		fastq/S1/F2_R1.fastq.gz		fastq/S1/F2_R2.fastq.gz	RGID1a	SampleID1	Lib1	UM		ILLUMINA 
Sample2		fastq/S2/F1_R1.fastq.gz		fastq/S2/F1_R2.fastq.gz	RGID2	SampleID2	Lib2	UM		ILLUMINA 
Sample2		fastq/S2/F2.fastq.gz		.						RGID2	SampleID2	Lib2	UM		ILLUMINA 

```

where, 

 - first should will be the column names
 - first column should contain sample names (this will be used to name the output files)
 - second column should contain the full path to the fastq file read1
 - third column should contain the full path to the fastq file read2 (if no read2, just keep a dot `.`)
 - other columns are self explanatory (just add the read group information according to your sample)


## alignment 

Just create a sh file as following,

```
#!/bin/sh
source /com/extra/gcc/5.2.0/load.sh
source /com/extra/zlib/1.2.8/load.sh
source /com/extra/cmake/3.3.2/load.sh
source ~/.bashrc

gotcloud align \
	--list <specify the list file created in previous step> \
	--outdir < specify the path to folder where you want the output>  \
	--numjobs <number of samples> \
	--threads 4 \
	--batchtype slurm \
	--batchopts "--mem=32g -c 4 --time=48:00:00 "
```
save this `sh` file (lets say `run.sh`)

Now submit the job to cluster

`sbatch --mem=8g run.sh`

Now you will see jobs running in the cluster. Wait till the all the jobs are done.

## variant calling 

Create a sh file like the one below,
```
#!/bin/sh
source /com/extra/gcc/5.2.0/load.sh
source /com/extra/zlib/1.2.8/load.sh
source /com/extra/cmake/3.3.2/load.sh
source ~/.bashrc
gotcloud snpcall \
	--list bam.list \ #this will be already created as part of step 1 
	--chrs 1 \ #which chromosome to call 
	--batchtype slurm \
	--batchopts "--mem=32g -c 4 --time=48:00:00 -p normal" \
	--numjobs 10 #this will be number of samples 
```

save it as , let's say `run.variantcalling.sh`

submit to cluster

`sbatch --mem=8g run.variantcalling.sh`

wait till all the jobs are done. 

## LD refinement 
 
 create a sh file exactly like before, except that replace `snpcall` with `ldrefine`
 So the file will look like 
```
#!/bin/sh
source /com/extra/gcc/5.2.0/load.sh
source /com/extra/zlib/1.2.8/load.sh
source /com/extra/cmake/3.3.2/load.sh
source ~/.bashrc
gotcloud ldrefine \
	--list bam.list \ #this will be already created as part of step 1 
	--chrs 1 \ #which chromosome to call 
	--batchtype slurm \
	--batchopts "--mem=32g -c 4 --time=48:00:00 -p normal" \
	--numjobs 10 #this will be number of samples 
```

Save it as lets say, run.ldrefine.sh

then submit the job

`sbatch --mem=8g run.ldrefine.sh`

Wait till the jobs are done. Then you are done. :)
