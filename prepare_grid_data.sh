#!/bin/bash

spk=$1

if [ -z $spk ]; then
    echo please input a speaker $spk
    exit
fi

in_root=data/grid-raw
out_root=data/grid

in_dir=$in_root/detect/$spk
echo Processing $in_dir
out_dir=$out_root/$(basename $in_dir)

vids=$(ls $in_dir/*.mp4)
for vid in $vids; do
    cut_out_dir=$out_dir/preprocessed/$(basename $vid .mp4)/cut/
    if [ ! -d $cut_out_dir ]; then
        mkdir -p $cut_out_dir
        echo $vid ...
        ffmpeg -i $vid -vsync 0 -q:v 2 $cut_out_dir/%d.jpg  -loglevel error
        wav=${vid/detect/audiotrack}
        wav=${wav/.mp4/.wav}
        cp $wav $cut_out_dir
        mv $cut_out_dir/*.wav $cut_out_dir/audio.wav
    fi
done

cat $in_root/train.csv | grep $spk/ | cut -d "|" -f1 | cut -d "/" -f2 > $out_dir/train.txt
cat $in_root/valid.csv | grep $spk/ | cut -d "|" -f1 | cut -d "/" -f2 > $out_dir/val.txt
cat $in_root/test.csv | grep $spk/ | cut -d "|" -f1 | cut -d "/" -f2 > $out_dir/test.txt
