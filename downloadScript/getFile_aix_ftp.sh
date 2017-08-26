#!/usr/bin/ksh
# 功能：从ftp服务器上下载应用包
# 参数说明：
#   [参数1]：源文件
#   [参数2]：日志文件名
# 调用示例：./getFile_aix_ftp.sh /UAT_803_V04.00_20160302_01.zip log1.log

# 以下配置开发和生产环境配置不一样---
ftpIp=99.1.38.181
ftpUser=ftpuser1
ftpPwd=123456
# -----------------------------------

srcFullFile=$1
logName=$2
srcFileName=${srcFullFile##*/}

labelRepo=/tmp/labelRepo/
ymd=$(date "+%Y%m%d")
downloadPath=${labelRepo}${ymd}/
# 保证下载路径已存在
if [[ ! -d $downloadPath ]]
then
    mkdir -p $downloadPath
fi

downloadFile=$downloadPath$srcFileName
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

# 执行ftp下载动作
exec 6>&1 1>>${logFullFile}
ftp -vn <<- EOF
open $ftpIp
user $ftpUser $ftpPwd
bin
size $srcFullFile
get $srcFullFile $downloadFile
bye
EOF

# 将重定向的标准输出从文件描述符6恢复到描述符1
exec 1>&6
# 关闭文件描述符6
exec 6>&-
# 记录结束时间
endSecond=$(date +%s)
endDate=$(date "+%Y-%m-%d %H:%M:%S")
echo "end download:"$endDate>>$logFullFile
echo "expend second:"$(($endSecond-$startSecond))>>$logFullFile
chmod -R 755 $labelRepo

# 判断下载结果
grep -q "Transfer complete" $logFullFile
if [[ $? -eq 0 ]]
then
    echo "downloadSuccess"
else
    echo "downloadFailed"
fi

