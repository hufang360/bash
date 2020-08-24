#!/bin/bash
# author：hf



# 带参数转码
ffmpegWithParam(){
  exeBefore
  echo "${outFile}"
  echo $x:$y:$w:$h:$fps
  "${ff}" -hide_banner -y \
   -i "${inFile}" \
   -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444 \
   -acodec copy \
   -s 1920x1080 -r $fps \
   -vf "scale=$w:$h,pad=1920:1080:$x:$y:0x00000000" \
   -sws_flags "neighbor" \
   "${outFile}"

   exeAfter
}


# 直接转码
ffmpegNoParam(){
  exeBefore
  echo "${outFile}"

  # 将gif转成mov
  "${ff}" -hide_banner -y \
    -i "${inFile}" \
    -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444 \
    -acodec copy \
    "${outFile}"

  exeAfter
}

exeBefore(){


  # 自定义保存目录
  shParent=$(cd `dirname $0`; pwd)
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

  # 开始转码
  count=0
  failCount=0
  lastFile=""
  fExt=${iFile##*.}
  tmp=${iFile##*/}
  fName=${tmp%.*}

  inFile="${iFile}"
  outFile="${outDir}"/"${fName}"".mov"
  echo "正在处理："$inFile
}


exeAfter(){
  # 检查mov是否生成完成
  if [ -e "${outFile}" ]; then
      let count=$count+1
      lastFile="${outFile}"
  else
      let failCount=$count+1
      curTime=$(date "+%Y-%m-%d %H:%M:%S")
      echo ${curTime} "生成mov失败：""${outFile}" >> "${outDir}"/"log.txt"
  fi

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
      echo "你拖入的文件夹是：""${iFile}"
  fi
}


#### 交互提示

# 提示拖入文件
# test
echo "拖入gif，然后按确认键:"
read iFile
if [ ! -n "$iFile" ]; then
  echo "请拖入gif，重来！"
  exit 0
fi


echo 是否需要处理成 1080p？,默认“y”（y/n）：
read c
if [ ! -n "$c" ]; then
 c="y"
fi
if [ "$c" == "Y" ]; then
 c="y"
fi


if [ "$c" == "y" ]; then
  echo 输入x坐标，默认“0”：
  read x
  echo 输入y坐标，默认“0”：
  read y
  echo 输入宽度，默认“使用gif宽度”：
  read w
  echo 输入宽度，默认“使用gif高度”：
  read h
  echo 输入帧率，默认是“30”：
  read fps
  if [ ! -n "$x" ]; then
    x="0"
  fi
  if [ ! -n "$y" ]; then
    y="0"
  fi
  if [ ! -n "$w" ]; then
    w="iw"
  fi
  if [ ! -n "$h" ]; then
    h="ih"
  fi
  if [ ! -n "$fps" ]; then
    fps="30"
  fi

  ffmpegWithParam
else
  ffmpegNoParam
fi

