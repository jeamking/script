#!/usr/bin/ksh
# 从artifactory服务器上下载发布包
# 参数说明：
#   [参数1]：源文件url
#   [参数2]：下载到本地的文件名
#   [参数3]：日志文件名
# 调用示例：./getFile_aix_artifactory.sh http://xx.xx.xx.xx:8081/artifactory/UAT_20170516_01.zip 
#            UAT_20170516_01.zip artiLog.log

# 以下配置开发和生产环境配置不一样---
# artifactory账号和密码
auth=8037:@2017
# -----------------------------------

srcFileUrl=$1
localFile=$2
logName=$3

saScriptHome=$(cd $(dirname $0); pwd)/
saMgrPluginHome=${saScriptHome}getFilePlugin
labelRepo=/tmp/labelRepo/
ymd=$(date "+%Y%m%d")
downloadPath=${labelRepo}${ymd}/
# 保证下载路径已存在
if [[ ! -d $downloadPath ]]
then
    mkdir -p $downloadPath
fi

downloadFile=${downloadPath}$localFile
pluginHome=${labelRepo}getFilePlugin/
logPath=${downloadPath}logs/
logFullFile=${logPath}${logName}
if [[ ! -d "$logPath" ]]
then  
    mkdir $logPath
fi

# 记录开始时间
startDate=$(date "+%Y-%m-%d %H:%M:%S")
startSecond=$(date +%s)
echo "params:"$*>$logFullFile
echo "begin download:"$startDate>>$logFullFile

# 判断插件是否安装
if [[ ! -f "${pluginHome}getFile.jar" ]]
then
    echo "notFindGetFilePlugin ${pluginHome}getFile.jar">>$logFullFile
    echo "notFindGetFilePlugin"
    exit 0
fi

# 插件执行下载功能
cpOptions=""
for f in $(ls ${pluginHome}libs/*.jar)
do
    fname=$(basename $f)
    cpOptions="${cpOptions}${pluginHome}libs/$fname:"
done
cpOptions="${cpOptions}${pluginHome}getFile.jar GetFileMain $srcFileUrl $auth ${downloadPath} $localFile"
echo "java -Xms256M -Xmx1024M -cp ${cpOptions}">>$logFullFile
java -Xms256M -Xmx1024M -cp ${cpOptions}>>$logFullFile 2>&1

# 记录结束时间
endSecond=$(date +%s)
endDate=$(date "+%Y-%m-%d %H:%M:%S")
echo "\nend download:"$endDate>>$logFullFile
echo "expend second:"$(($endSecond-$startSecond))>>$logFullFile
chmod -R 755 $labelRepo

# 判断下载结果
grep -q "downloadSuccess" $logFullFile
if [[ $? -eq 0 ]]
then
    echo "downloadSuccess"
else
	  rm -rf $downloadFile
    echo "downloadFailed"
fi
