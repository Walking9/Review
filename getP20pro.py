#!/usr/bin/env python
# coding=utf-8

from selenium import webdriver
import time

def get_sys_time():
	sys_time = time.time()
	print sys_time
	return sys_time

def set_stamp():
	#set_time = '2018-05-04 10:07:40'  # 设置抢购时间，最好提前,登录需要时间
	#set_time = '2018-05-04 15:59:40'
	set_time = '2018-05-04 19:59:40'
    # 将其转换为时间数组
	time_array = time.strptime(set_time, '%Y-%m-%d %H:%M:%S')
    # 转换为时间戳
	time_stamp = int(time.mktime(time_array))
	print time_stamp
	return time_stamp

#main
try:
	while True:
		time.sleep(10)
		print 'sleep...'
		if get_sys_time() >= set_stamp():   #时间到，开抢
			print 'strat...'
			driver=webdriver.Chrome()
			driver.get(r'https://www.vmall.com/product/10086471194207.html')
			#print '@@@driver attributes:'
			#print dir(driver)

			#print '@@@WebElement attributes:'
			#print dir(elem)
			driver.find_element_by_class_name('product-button02').click()
			driver.find_element_by_id('login_userName').send_keys('username')
			driver.find_element_by_id('login_password').send_keys('password')
			driver.find_element_by_class_name('button-login').click()
			driver.find_element_by_xpath("//span[contains(text(),'极光色')]").click()
			while True:
				driver.find_element_by_class_name('product-button02').click()
				if driver.title == u'【HUAWEI P20系列】4000万徕卡三摄* | AI摄影大师-新品首发':
					while True:
						print 'wait.....'
						if driver.title == u'确认订单华为商城':
							break;
					print 'GET IT!!!!!!!!'
					driver.find_element_by_id('submit_order_button').click() # 提交订单，赶快付款
			print driver.title
#	else:
#		print u'时间设置错误'
except Exception, e:
    print e
#time.sleep(5)
	
#elem.get_attribute('class')
