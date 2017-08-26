#!/bin/bash
# 功能：安装artifactory插件
# 参数说明：
#   [参数1]：sa主机名
#   [参数2]：label库主目录，比如：/d/labelRepo/

saHostName=$1
labelRepo=$2

# 以下配置开发和生产环境配置不一样---
getpath=/home/nemo/bin/getpath
# -----------------------------------

saScriptHome=$(cd $(dirname $0); pwd)/
pluginHome=${labelRepo}getFilePlugin/
remotePath="$($getpath -s $saHostName -d $pluginHome)"
# 将远程目录中的/root/替换为/cmbadmin/
remotePath=${remotePath/\/root\//\/cmbadmin\/}

result="$(cp -r ${saScriptHome}getFilePlugin $remotePath 2>&1)"
if [[ -z "$result" ]]
then
  echo installResult:true
else
  echo installResult:false
fi

