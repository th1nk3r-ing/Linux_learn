#/bin/sh

DIR="callRes"

for line in $(ls ${DIR})
do
    outFile="${DIR}/"${line:0:4}"_small.png"
    ffmpeg -i "${DIR}/"${line} -vf "scale=iw/5:ih/5" ${outFile}
    # echo "${outFile}"
done
