# [将一个目录下的 GB2312 文件批量转换为 UTF-8 的方法](https://www.cnblogs.com/bamanzi/archive/2012/06/12/convert-all-gb2312-files-to-utf-8.html)
files=`find . -name '*.txt' | xargs enca -L zh | grep GB2312 | cut -d: -f1`
for f in $files; do
	iconv -f GBK -t UTF-8 $f > $f.utf && mv -f $f.utf $f && echo "$f done"    
done
