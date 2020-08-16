#!/bin/bash
# author：hf

# 提示拖入文件
# test
echo "拖入文件夹，然后按确认键:"
read iDir
if [ ! -n "$iDir" ]; then
  echo "请拖入文件夹，重来！"
  exit 0
fi

shParent=$(cd `dirname $0`; pwd)
# 自定义保存目录
outDir="$shParent"/"_gif2mov"
if [ ! -d "${outDir}" ];then
  mkdir "${outDir}"/
fi

# 检查 ffmpeg
ff="$shParent"/ffmpeg
if [ ! -f "${ff}" ];then
  echo ffmpeg 命令行工具不存在，脚本无法正常工作！
  echo 请放入ffmpeg再进行操作
  exit
else
  # 设置ffmpeg命令行工具为可执行
  chmod +x "${ff}"
  xattr -rd com.apple.quarantine "${ff}"
fi


# 读取目录
count=0
failCount=0
lastFile=""
cd "${iDir}"
for file in *.gif; do
    fExt=${file##*.}
    tmp=${file##*/}
    fName=${tmp%.*}

    # test
    # echo ${file}
    # echo ${fName}
    # echo ${fExt}

    inFile="${iDir}"/"${file}"
    outFile="${outDir}"/"${fName}"".mov"
    echo "正在处理："$inFile

    # 将gif转成mov
    ffmpeg -hide_banner -y \
     -i "${inFile}" \
     -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444 \
     -acodec copy \
     "${outFile}"
    
    # 检查mov是否生成完成
    if [ -e "${outFile}" ]; then
        let count=$count+1
        lastFile="${outFile}"
    else
        let failCount=$count+1
        curTime=$(date "+%Y-%m-%d %H:%M:%S")
        echo ${curTime} "生成mov失败：""${outFile}" >> "${outDir}"/"log.txt"
    fi
done

echo $count
# 提示结果
if [ $count -gt 0 ]; then
    echo "生成的mov，保存在 ${outDir}"
    echo "正在打开保存目录"
    # 自动在Finder中,选中最后一张图片
    open -R "${lastFile}"/
else
    echo "没有生成任何mov!!!"
    echo "  请检查文件夹下是否有gif文件；"
    echo "  确保保存目录拥有读写权限；"
    echo "你拖入的文件夹是：""${iDir}"
fi