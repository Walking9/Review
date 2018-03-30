#!/bin/bash
echo "Hello World!"
echo "新建的shell脚本需要加执行权限+x，或者使用解释器/bin/sh执行"

echo "*********************************shell变量**********************************"
str="string"    #变量，注意变量和等号之间没有空格
#for file in 'ls/etc'  #将 /etc 下目录的文件名循环出来
for skill in Ada Coffe Action Java; do
    echo "I am good at ${skill}Script"  #使用变量需要加${},括号是为了帮助解释器识别变量边界
done
readonly str    #只读变量
str2="string2"
unset str2       #删除变量，unset不能删除只读变量
echo "shell存在三种变量，局部变量、环境变量、shell变量"
#shell字符串可以用单引号或者双引号
#单引号字符串的限制：原样输出，里面不能有单引号
#双引号字符串优点：里面可以有变量，可以有转义字符

echo ${#str}    #获取字符串长度
echo ${str:1:4} #提取子字符串
longString="beijing shanghai hefei dajiahao"
#查找子字符串：例如qf,先找q，没有，再找f，返回位置，如果都没有返回0
#注意查询格式`expr index "变量名" 目标子字符串`
echo `expr index "${longString}" qf`

#shell数组，只支持一维数组，元素用空格隔开
array=(a1 a2 a3 a4)
echo ${array[*]}    #获取所有元素或者array[@]
#shell只有#注释

echo "*****************************shell传递参数*********************************"
# $0执行文件名 $n 第n个参数
# $# 参数个数， $*显示所有参数 $$脚本运行进程id $!后台运行最后一个进程id $@与$*类似 $-显示shell使用当前选项 $?显示最后命令退出状态
echo "Shell 传递参数实例！"
echo "第一个参数为：$1"
echo "参数个数为：$#"
echo "传递的参数作为一个字符串显示*：$*"
echo "传递的参数作为一个字符串显示@：$@"
echo "脚本运行的id号：$$"
echo "后台运行最后一个进程id：$!"
echo "shell使用当前选项：$-"
echo "最后命令退出状态：$?"
#$* 与 $@ 区别：
#相同点：都是引用所有参数。
#不同点：只有在双引号中体现出来。假设在脚本运行时写了三个参数 1、2、3，，则 " * " 等价于 "1 2 3"（传递了一个参数），而 "@" 等价于 "1" "2" "3"（传递了三个参数）。

echo "*******************************shell运算符***********************************"
echo "包括：算数、关系、布尔、字符串、文件测试运算符"
#原生bash不支持数学运算，但可以通过命令来实现，如awk、expr；
val=`expr 2 + 2`   #加号（运算符）两边必须有空格。。。。
echo "用expr计算2+2得${val}"
#关系运算符：
# -eq是否相等 -ne是否不等 -gt左边大？ -lt左边小？ -ge左边大于等于？ -le左边小于等于？
#布尔运算符：
# ！非运算 -o或运算 -a与运算
#逻辑运算符：
# &&逻辑与  ||逻辑或
a=10
b=20
if [ $a -lt 100 -a $b -gt 15 ]
then
   echo "$a 小于 100 且 $b 大于 15 : 返回 true"
else
   echo "$a 小于 100 且 $b 大于 15 : 返回 false"
fi
#字符串运算符：
# =判断相等  !=判断不等 -z长度是否为0 -n长度是否不为0 [string]检测是否为空
a="dsfa"
if [ $a -z ]  #顺序没有要求
then
   echo "-z $a : 字符串长度为 0"
else
   echo "-z $a : 字符串长度不为 0"
fi

#文件测试运算符
# 用于测试unix文件各种属性 -b是否块设备文件 -c字符设备文件？ -d目录？ -f普通？(不是块设备也不是目录)
# -g是否设置了SGID位？ -k设置了粘着位？ -p有名管道？ -u设置了SUID位？ -r可读？ -w可写？ -x可执行？ 
# -s为空？ -e文件（包括目录）存在？
file="/etc"
if [ -d $file ]
then
   echo "${file}文件是个目录"
else
   echo "${file}文件不是个目录"
fi
echo `date`

echo "******************************shell echo、printf、test命令*********************************"
#printf 命令模仿 C 程序库（library）里的 printf() 程序
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234 
#%s %c %d %f都是格式替代符
#%-10s 指一个宽度为10个字符（-表示左对齐，没有则表示右对齐），任何字符都会被显示在10个字符宽的字符内，如#果不足则自动以空格填充，超过也会将内容全部显示出来。
#%-4.2f 指格式化为小数，其中.2指保留2位小数。

#代码中的 [] 执行基本的算数运算，如：
a=5
b=6
result=$[a+b] # 注意等号两边不能有空格
echo "result 为： $result"
cd /bin
if test -e ./bash
then
    echo '文件已存在!'
else
    echo '文件不存在!'
fi

echo "***********************************shell流程控制*************************************"
#if else-if else 语法格式：（经常与test命令结合使用）
a=10
b=20
if [ $a == $b ]
then
   echo "a 等于 b"
elif [ $a -gt $b ]
then
   echo "a 大于 b"
elif [ $a -lt $b ]
then
   echo "a 小于 b"
else
   echo "没有符合的条件"
fi

#for循环一般格式为：
for loop in 1 2 3 4 5
do
    echo "The value is: $loop"
done

#while语句格式：   #可以用break、continue,效果一样
int=1
while(( $int<=5 ))
do
    echo $int
    let "int++"
done

#case语句格式，以及控制台读入一个数：

echo '输入 1 到 4 之间的数字:'
echo '你输入的数字为:'
read aNum        #read读入一个数
case $aNum in
    1)  echo '你选择了 1'
    ;;
    2)  echo '你选择了 2'
    ;;
    3)  echo '你选择了 3'
    ;;
    4)  echo '你选择了 4'
    ;;
    *)  echo '你没有输入 1 到 4 之间的数字'
    ;;
esac

echo "**********************************shell函数**********************************"
#shell中函数的定义格式如下：
#[ function ] funname [()]
#{
#
#    action;
#
#    [return int;]
#
#}
funWithReturn(){
    echo "这个函数会对输入的两个数字进行相加运算..."
    echo "输入第一个数字: "
    read aNum
    echo "输入第二个数字: "
    read anotherNum
    echo "两个数字分别为 $aNum 和 $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn
echo "输入的两个数字之和为 $? !" #函数返回值在调用该函数后通过 $? 来获得
funWithParam(){
    echo "第0个参数为 $0 !"
    echo "第二个参数为 $2 !"
    echo "第十个参数为 $10 !"
    echo "第十个参数为 ${10} !"
    echo "第十一个参数为 ${11} !"
    echo "参数总数有 $# 个!"
    echo "作为一个字符串输出所有参数 $* !"
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73  #函数传参，与执行传参类似

echo "***************************shell输入输出重定向****************************"
#终端输入命令后，默认从终端输出结果，可以通过重定向来改变数据流方向
#输出重定向会覆盖文件内容，请看下面的例子：
#$ echo "菜鸟教程：www.runoob.com" > users 这样users文件就有了对应的输出结果，如果不希望文件被覆盖，可用>>追加到文件末尾
#输入重定向同理
#command1 < infile > outfile
#同时替换输入和输出，执行command1，从文件infile读取内容，然后将输出写入到outfile中。


#一般情况下，每个 Unix/Linux 命令运行时都会打开三个文件：
#标准输入文件(stdin)：stdin的文件描述符为0，Unix程序默认从stdin读取数据。
#标准输出文件(stdout)：stdout 的文件描述符为1，Unix程序默认向stdout输出数据。
#标准错误文件(stderr)：stderr的文件描述符为2，Unix程序会向stderr流中写入错误信息。

#如果希望将 stdout 和 stderr 合并后重定向到 file，可以这样写：
#$ command > file 2>&1

#Here Document 是 Shell 中的一种特殊的重定向方式，用来将输入重定向到一个交互式 Shell 脚本或程序。
#它的基本的形式如下：
#command << delimiter
#    document
#delimiter
#它的作用是将两个 delimiter 之间的内容(document) 作为输入传递给 command。

#/dev/null 是一个特殊的文件，写入到它的内容都会被丢弃；如果尝试从该文件读取内容，那么什么也读不到。但是 /dev/null 文件非常有用，将命令的输出重定向到它，会起到"禁止输出"的效果。

echo "*******************************shell文件包含*********************************"
#使用 . 号来引用test1.sh 文件
. ./test1.sh          #前提是要有test1.sh脚本，该句话相当于include
echo "${test1Var}"    #test1.sh脚本里有个test1Var变量，在这里可以引用

