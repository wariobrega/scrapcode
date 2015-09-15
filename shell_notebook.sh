##extract the first n lines from a compressed txt file

gzip -cd compressed.gz | head -n4000 > test.txt
