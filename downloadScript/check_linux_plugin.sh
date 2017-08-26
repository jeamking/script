#!/bin/bash
# 检查artifactory下载插件是否存在
# 参数说明：

labelRepo=/tmp/labelRepo/
# 保证labelRepo路径已存在，为推送插件做好准备
if [[ ! -d $labelRepo ]]
then
    mkdir -p $labelRepo
fi
pluginHome=${labelRepo}getFilePlugin/

# 判断插件是否安装
if [[ -f "${pluginHome}getFile.jar" ]]
then
    echo "isInstallPlugin:true"
else
	  echo "isInstallPlugin:false"
fi
