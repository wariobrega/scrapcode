##few notes on several comman liune tools in testing

##trimmomatic: tool to trim raw reads according to specific criteria

#remove reads from two paired end fastq files using a MAXINFO approach of 0.2 (see paper) and keep reads of at least 75 nucleotides of length

java -jar PATH/TO/trimmomatic.jar PE -threads 4 -phred33 \
-trimlog PATH/TO/LOG/FILE.log \
PATH/TO/READ1/FILE.fastq \
PATH/TO/READ2/FILE.fastq \
PATH/TO/FINAL/PAIRED_FILE1_paired.fastq \
PATH/TO/FINAL/UNPAIRED_FILE1_unpaired.fastq \
PATH/TO/FINAL/PAIRED_FILE2_paired.fastq \
PATH/TO/FINAL/UNPAIRED_FILE2_unpaired.fastq \
MAXINFO:75:0.2 MINLEN:75 &

###Sort vcf according to chromosome name:

perl vcf_sort.pl `echo chr{{1..22},X,Y,M} | tr ' ' ','` PATH/TO/UNSORTED.vcf > PATH/TO/SORTED.vcf

###STAR-RNASEQ###

#Create a Genome Index

./STAR \ 
--runMode genomeGenerate \ 
--genomeDir PATH/TO/OUTPUT/DIRECTORY 
--genomeFastaFiles PATH/TO/REFERENCE.fa \
--sjdbGTFfile PATH/TO/ANNOTATION.gff \ 
--limitGenomeGenerateRAM 30000000000 \ 
--sjdbOverhang 99 


##Qualimap BAMQC
./qualimap --java-mem-size=4G bamqc \
-bam PATH/TO/BAM \
-gff PATH/TO/REGIONS.gff \
--outside-stats \
-nt 2 
--output-genome-coverage PATH/TO/PERBASE/COVERAGE.cov 

##PICARD

##AddOrreplaceReadGroup
java -jar /data01/Software/picard/picard.jar AddOrReplaceReadGroups \
-Djava.io.tmpdir=PATH/TO/TMP/ \
I=/PATH/TO/INPUT.bam \
O=/PATH/TO/OUTPUT.bam \
RGPL="Machine_used" RGLB="Read_Owner" RGPU="whatever" RGSM="whatever"

##ReorderSam (according to reference FA)

java -Djava.io.tmpdir=/data01/tmp/d.capocefalo/ -jar /data01/Software/picard/picard.jar ReorderSam \
I=/PATH/TO/INPUT.bam \
O=/PATH/TO/OUTPUT.bam \
R=/PATH/TO/REFERENCE.fa
