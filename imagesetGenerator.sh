#!/bin/sh

ScalePic () {
    imageHeight=`sips -g pixelHeight $1 | awk -F: '{print $2}'`
    imageWidth=`sips -g pixelWidth $1 | awk -F: '{print $2}'`
    height=`echo $imageHeight`
    width=`echo $imageWidth`

    height2x=$(($height*2/3))
    width2x=$(($width*2/3))

    height1x=$(($height/3))
    width1x=$(($width/3))


    imageFile=$1
    fileName2x=${imageFile/\.png/@2x\.png}
    fileName3x=${imageFile/\.png/@3x\.png}

    cp $imageFile $fileName3x
    sips -z $height2x $width2x $1 --out $fileName2x
    sips -z $height1x $width1x $1
}

Contents () {
    imageFile=$1
    renameFile2x=${imageFile/\.png/@2x\.png}
    renameFile3x=${imageFile/\.png/@3x\.png}

    echo {  >> Contents.json
    echo "  \"images\"" : [>> Contents.json
    echo "   "{>> Contents.json
    echo "      \"idiom\"" : "\"universal\"",>> Contents.json
    echo "      \"scale\"" : "\"1x\"",>> Contents.json
    echo "      \"filename\"" : "\"$imageFile\"">> Contents.json
    echo "   "},>> Contents.json
    echo "   "{>> Contents.json
    echo "      \"idiom\"" : "\"universal\"",>> Contents.json
    echo "      \"scale\"" : "\"2x\"",>> Contents.json
    echo "      \"filename\"" : "\"$renameFile2x\"">> Contents.json
    echo "   "},>> Contents.json
    echo "   "{>> Contents.json
    echo "      \"idiom\"" : "\"universal\"",>> Contents.json
    echo "      \"scale\"" : "\"3x\"",>> Contents.json
    echo "      \"filename\"" : "\"$renameFile3x\"">> Contents.json
    echo "   "}>> Contents.json
    echo " "],>> Contents.json
    echo "  \"info\"" : {>> Contents.json
    echo "     \"version\"" : 1,>> Contents.json
    echo "     \"author\"" : "\"xcode\"">> Contents.json
    echo " "}>> Contents.json
    echo }>> Contents.json

}

cd $1
# 1 遍历$1文件夹下的所有文件，即所有图片素材了。
for file in ./*
do
    # 2 获取图片的文件名，并生成 “文件名.imageset”文件夹，方便下一步处理
    imageFile=$(basename $file)
    imageDir=${imageFile/\.png/\.imageset}
    mkdir $imageDir

    # 3 将图片拷贝入“文件名.imageset”文件夹，并进入该文件夹
    cp $imageFile $imageDir/
    cd $imageDir

    # 4 执行ScalePic函数，将图片文件名作为参数。
    #   执行Contents函数，生成描述文件Contents.json
    #   最后处理完后，退回上一级目录
    ScalePic $imageFile
    Contents $imageFile
    cd ..
done
cd ..