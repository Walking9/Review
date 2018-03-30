#!/usr/bin/python3
# coding=utf-8   
#注释, 上面的编码解决了代码中允许出现汉字

# 在 python 用 import 或者 from...import 来导入相应的模块。
# import somemodule
# from somemodule import somefunction
from sys import argv,path
import sys

print("============================python3基本语法=========================================")
'''
注释
'''

"""
注释
"""
print("Hello, World")

if True:
	print("True")
# elif <==> else if
else:
	print("False")

a = 1;
b = 2;
c = a + \
	b
print(c)

paragraph = """这是一个段落，
可以由多行组成"""
print(paragraph);

print("python"); print("可以在同一行显示多条语句，之间用分号隔开");print("但这就不是python风格了");
print("print默认换行输出")
print("print", end=' ')
print('可以不换行输出')
print('path: ', path)

#input("\n\n按下 enter 键后退出")

print("============================python3基本数据类型=========================================")
counter = 100    #整型变量
miles   = 1000.12  #浮点型变量
name    = "python3" #字符串
boolPython = True   #布尔类型
print(counter)
print(miles)
print(name)
print(boolPython)
print("python3标准数据类型6个：Number数字、String字符串、List列表、Tuple元组、Sets集合、Dictionary字典")
print("数字有int、float、bool、complex复数")
a, b, c, d = 20, 1.2, True, 4+9j
print("使用type()查看数据类型, 或者使用isinstance(a, int): ")
print(type(a), type(b), type(c), type(d))
paragraph = """type()不会认为子类是一种父类类型。
isinstance()会认为子类是一种父类类型。
"""
print(paragraph)
print("使用del删除对象引用")
word = 'Python'
print(word[0], word[5], word[-1], word[-6])  #-1位置表示倒数第一个，字符串不可被赋值同样，字符串越界会报错
listPython = ['asdf', 4585, 2.6, 324, 3]
print(listPython[1:])   #输出第二个开始的所有元素
print(listPython * 2)   #连续输出两次列表
listPython[3] = 84      #与字符串不同，列表中的元素可以被改变
print(listPython)
print("元组与列表相似，但元组的元素不能修改")
tuplePython = ('ew', 4.5, 33)
onlyOneTuple = (22,)    # 一个元素要在后面添加逗号
print(tuplePython + onlyOneTuple)
print("set是一个无序不重复的序列，会对成员关系测试，删除重复元素")
student = {'A', 'R', 'B', 'C', 'A', 'a'}
print(student)
print('集合之间可以进行差、并、交、补运算')
print('dictionary相当于map，是一种映射类型，是无序的键值对集合')
dict = {}
dict['one'] = "1 - 菜鸟教程"
dict[2]     = "2 - 菜鸟工具"
 
tinydict = {'name': 'runoob','code':1, 'site': 'www.runoob.com'}
 
print (dict['one'])       # 输出键为 'one' 的值
print (dict[2])           # 输出键为 2 的值
print (tinydict)          # 输出完整的字典
print (tinydict.keys())   # 输出所有键
print (tinydict.values()) # 输出所有值
print("小结：list用[], tuple用(), sets、dictionary用{}")
print("最后，可以使用各种函数进行数据类型转换：http://www.runoob.com/python3/python3-data-type.html")


print("============================python3解释器=========================================")
print("linux上一般默认python版本2.x，下载python3，设置环境变量输入python命令启动python解释器")

print("============================python3编程=========================================")
# Fibonacci series : 斐波那契数列
a, b = 0,1
print("Fibonacci:", end=' ')
while b < 100:
	print(b, end=',')
	a, b = b, a+b
print()
print("python迭代器")
list = [1, 2, 3, 4, 5]
it = iter(list)   #创建迭代器对象，迭代器从第一个元素开始访问，只进不退
print(next(it), next(it))
for i in it:      #与for i in list相似
	print(i, end=",")
print()
print("python生成器：使用了yield函数")

def fibonacci(n): # 生成器函数 - 斐波那契
    a, b, counter = 0, 1, 0
    while True:
        if (counter > n): 
            return
        yield a
        a, b = b, a + b
        counter += 1
f = fibonacci(10) # f 是一个迭代器，由生成器返回生成
# 在调用生成器运行的过程中，每次遇到 yield 时函数会暂停并保存当前所有的运行信息，返回 yield 的值, 并在下
# 一次执行 next() 方法时从当前位置继续运行。
# 调用一个生成器函数，返回的是一个迭代器对象。
i = 10
while i:
    try:
        print (next(f), end=" ")
        i -= 1
    except StopIteration:
        sys.exit()
print()
print('python函数')
def area(width, height):
	return width * height;
w = 4
h = 5
print("width =", w, " height =", h, " area =", area(w, h))
# python函数也有类似传值和引用的区别
# python函数传参有：必须参数、关键字参数、默认参数、不定长参数
# 关键字、默认参数举例：
def printinfo( name, age = 25):   #在没有age参数时默认为25
   "打印任何传入的字符串"
   print ("名字: ", name);
   print ("年龄: ", age);
   return;

printinfo( age=50, name="runoob" ); #调用printinfo函数

# 加了星号（*）的变量名会存放所有未命名的变量参数。如果在函数调用时没有指定参数，它就是一个空元组
# 不定长参数举例：
def function( arg1, *vartuple ):
   "打印任何传入的参数"
   print ("输出: ")
   print (arg1)
   for var in vartuple:
      print (var)
   return;
# python 使用 lambda 来创建匿名函数。
# 匿名函数举例：
sum = lambda arg1, arg2: arg1 + arg2;
# 调用sum函数
print ("相加后的值为 : ", sum( 10, 20 ))
# python变量作用域：
'''
Python的作用域一共有4种，分别是：
L （Local） 局部作用域
E （Enclosing） 闭包函数外的函数中
G （Global） 全局作用域
B （Built-in） 内建作用域
以 L –> E –> G –>B 的规则查找
'''
# 举例：
x = int(2.9)  # 内建作用域
g_count = 0  # 全局作用域
def outer():
    o_count = 1  # 闭包函数外的函数中
	global g_count    #使用全局变量要用global声明
    def inner():
        i_count = 2  # 局部作用域
# 内部作用域想修改外部作用域的变量时，就要用到global和nonlocal关键字
# nonlocal:
def outer():
    num = 10
    def inner():
        nonlocal num   # nonlocal关键字声明
        num = 100
        print(num)
    inner()
    print(num)
outer()



