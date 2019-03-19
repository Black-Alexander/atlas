#! /bin/bash
set -euo pipefail





atlas --version




databaseDir=".test/databases"
WD='.test/Test_assembly'
reads_dir=".test/reads/stub"

ressource_args=" --config java_mem=4 assembly_mem=4"


# gen randomreads
#very low number only for assembly
#snakemake -s atlas/rules/testing.smk -d $reads_dir --config reads=1000


rm -f $WD/samples.tsv
#
atlas init --db-dir $databaseDir --threads 4  -w $WD $reads_dir


atlas run -w $WD qc $ressource_args $@

atlas run assembly -w $WD $ressource_args assembler=spades $@

atlas run assembly -w $WD $@

atlas run assembly -w $WD $@

echo "copy qc reads and assemble"

WD2='.test/Test_assembly_skipQC'
reads_dir=".test/reads/stub_qc"


rm -f $WD2/samples.tsv
mkdir -p $reads_dir
cp $WD/*/sequence_quality_control/*_QC_R?.fastq.gz $reads_dir


atlas init --db-dir $databaseDir --threads 4 --assembler megahit --skip-qc -w $WD2 $reads_dir

atlas run -w $WD2 assembly $ressource_args $@
