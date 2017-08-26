#!/usr/bin/ksh
# 功能：安装artifactory插件
# 参数说明：
#   [参数1]：sa主机名

saHostName=$1

# 以下配置开发和生产环境配置不一样---
getpath=/home/nemo/bin/getpath
# -----------------------------------

saScriptHome=$(cd $(dirname $0); pwd)/
labelRepo=/tmp/labelRepo/
pluginHome=${labelRepo}getFilePlugin/
remotePath="$($getpath -s $saHostName -d $pluginHome)"

result="$(cp -r ${saScriptHome}getFilePlugin $remotePath 2>&1)"
if [[ -z "$result" ]]
then
  echo "installResult:true"
else
  echo "installResult:false"
fi

