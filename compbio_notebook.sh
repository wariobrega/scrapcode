##few notes on several comman line tools in testing

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

#Run STAR alignment with default parameters 
#use a temporary dir for dumping data
#use 30 cores
#produce a sorted BAM output
/PATH/TO/STAR/DIR/STAR \
--runThreadN 30 \ 
--genomeDir PATH/TO/GENOME/INDEX/ \
--readFilesIn PATH/TO/READ1.fastq PATH/TO/READ1.fastq \
--outTmpDir tmp \
--outSAMtype BAM SortedByCoordinate \
--outBAMsortingThreadN 4 \
-limitBAMsortRAM 12000000 \

##Qualimap BAMQC
./qualimap --java-mem-size=4G bamqc \
-bam PATH/TO/BAM \
-gff PATH/TO/REGIONS.gff \
--outside-stats \
-nt 2 
--output-genome-coverage PATH/TO/PERBASE/COVERAGE.cov 

##PICARD

##AddOrReplaceReadGroup
java -Djava.io.tmpdir=PATH/TO/TMP/ -jar /data01/Software/picard/picard.jar \
AddOrReplaceReadGroups \
I=/PATH/TO/INPUT.bam \
O=/PATH/TO/OUTPUT.bam \
RGPL="Machine_used" RGLB="Read_Owner" RGPU="whatever" RGSM="whatever"

##ReorderSam (according to reference FA)
java -Djava.io.tmpdir=/data01/tmp/d.capocefalo/ -jar /data01/Software/picard/picard.jar \
ReorderSam \
I=/PATH/TO/INPUT.bam \
O=/PATH/TO/OUTPUT.bam \
R=/PATH/TO/REFERENCE.fa


##RNASeqQC, collect metrics about RNA-Seq alignments
## (transcriptDetails produce an HTML version of the Report)
java -Djava.io.tmpdir=/data01/tmp/d.capocefalo/ -jar /data01/Software/RNASeqQC/RNA-SeQC_v1.1.8.jar \
-o /PATH/TO/OUTOUT/DIR \
-r PATH/TO/REFERENCE.fa \
-s "SAMPLENAME|SAMPLEPATH.bam|SAMPLENOTES" \
-t /PATH/TO/ANNOTATION.gtf \
-transcriptDetails &

##how2download a RefFlat file from UCSC and convert it to GTF
##(also found HERE: http://genomewiki.ucsc.edu/index.php/Genes_in_gtf_or_gff_format

genePredToGtf -source=UCSC -utr hg19 refGene hg19_ucsc.gtf

##command to launch RNA-Seq vladkim notebook in ipython (useful for me only)
sudo docker run --rm -it --net=host vladkim/rnaseq sh -c "ipython notebook --profile=nbserver --no-browser --ip=127.0.0.1"

##bamtools
#bamtools is a useful tool for better parse and operate through bam files without doing the annoying operations performed by samtools (more info on https://github.com/pezmaster31/bamtools, whichj also contains a better tutorial than
#the one that I'm writing now 4 sure!
#samtools can be used for a p'letora of things, included
#converting a bam to different format
#count the number of the reads/alignment within a subsets of BAMs
#gather alignment statistics
#And so on
#more importantly though, basmtools will FILTER your bam alignments using natural language rather than those pesky sam flags used in Samtools
#to do so, just use some of the many options listed using
/path/to/bamtools/bin/bamtools filter --help
#and, if you please, put them inside a file usin JSON synthax and call it through the --script command, as it follows
/path/to/bamtools/bin/bamtools filter -in in.bam -out out_filtered.bam -script filters.json 
#that will output the bam filtered for the commands you wanted

#looking at the filters.json file, it will look similar to this (see manual for more info on regards as it is explained perfectly):
{
"isMapped" : "true",
"isMateMapped" : "true",
"isPaired": "true",
"tag" : "NH:<2"
}
#meaning: discard unmapped reads, discard reads that does not have mate mapped, discard read if not paired, discard read if it has more than one possible alignment reported

#now let's combine bamtools with parallel on a subset of bam files (the results of an RNA-Seq run) for for filter all reads uniquely mapped and properly paired and gather pre and post statistics of such file
find /path/to/output/ -type f -name *.bam | parallel -tmpdir /path/to/tmp -j 12 /path/to/bamtools/bin/bamtools filter -in {} -out {.}_filtered_bamtools.bam -script rnaseq_filters.json '&&' /path/to/bamtools/bin/bamtools stats -in {} '>' {.}_stats.log '&&' /path/to/bamtools/bin/bamtools stats -in {.}_filtered_bamtools.bam '>' {.}_filtered_bamtools_stats.log '&&' 


#####
#General Command for launching  GATK Haplotype Caller
java -jar -Djava.io.tmpdir=PATH/TO/TMPDIR -Xmx4g PATH/TO/GATK -T HaplotypeCaller \
-stand_call_conf 20.0 -stand_emit_conf 10.0 \
-R PATH/TO/REFERENCE.FASTA \
--dbsnp PATH/TO/DBSNP.vcf \
-I PATH/TO/INPUT/RECAL.bam \
-O PATH/TO/VARIANTS.vcf

###



