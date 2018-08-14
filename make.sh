#!/bin/sh

traceroute google.com 1>>out.txt 2>> out.txt
#command -v python > out.txt
#wget http://185.199.108.0:22/Fysikteknologsektionen/Sangtexter/archive/master.tar.gz 2>> out.txt
#git clone http://github.com/Fysikteknologsektionen/Sangtexter.git 2>> out.txt
ls . -l >> out.txt
python download.py http://github.com/Fysikteknologsektionen/Sangtexter/archive/master.tar.gz
ls . -l >> out.txt
#echo "hej" >> out.txt

tar -xvf master.tar.gz
rmdir texter
mv Sangtexter-master texter

touch index.tex
touch sjungboken2.idx
pdflatex -halt-on-error sjungboken.tex

#Sortera låtar med 1 före 10 o.s.v.
#Funkar bara om de heter "...Nr XX...", typ "Fredmans epistel Nr 23: En liten visa"
echo Sorterar index..
sed -e 's/\\indexentry{Nr \([1-9]:.*\)/\\indexentry{Nr 0\1/' < sjungboken.idx > sjungboken2.idx
#Sortera åäö och ÅÄÖ rätt
sed -e '
:again
	s/^\([^@]*\)\\IeC {\\r a}/\1zaz/g
	t again
' -e '
:again2
	s/^\([^@]*\)\\IeC {\\r A}/\1ZAZ/g
	t again2
' -e '
:again3
        s/^\([^@]*\)\\IeC {\\"a}/\1zbz/g
        t again3
' -e '
:again4
        s/^\([^@]*\)\\IeC {\\"A}/\1ZBZ/g
        t again4
' -e '
:again5
        s/^\([^@]*\)\\IeC {\\"o}/\1zcz/g
        t again5
' -e '
:again6
        s/^\([^@]*\)\\IeC {\\"O}/\1ZCZ/g
        t again6
' < sjungboken2.idx > sjungboken3.idx

mv sjungboken3.idx sjungboken.idx

makeindex sjungboken.idx

cat sjungboken.ind | grep \item | sed -r s/'\\item '\([^,].+\),\ \(.*\),\ \(.*\),.*/'\\hyperref\[\3]{\1}\&\\hyperref\[\3]{\2}\\\\'/>indexsort.tex
cat indexhead.tex indexsort.tex indexfoot.tex > index.tex

rm sjungboken2.idx