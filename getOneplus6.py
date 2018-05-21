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
	set_time = '2018-05-29 15:59:20'
	#set_time = '2018-05-04 19:59:40'
    # 将其转换为时间数组
	time_array = time.strptime(set_time, '%Y-%m-%d %H:%M:%S')
    # 转换为时间戳
	time_stamp = int(time.mktime(time_array))
	print time_stamp
	return time_stamp

#main
try:
	while False:
		time.sleep(10)
		print 'sleep...'
		if get_sys_time() >= set_stamp():   #时间到，开抢
			print 'strat...'
			driver = webdriver.Chrome()
			#driver.get(r'https://rush.oneplus.com/cn/oneplus6')
			#一加官网验证码过不去，换用京东购买
			driver.get(r'https://item.jd.com/7357933.html#none')
			driver.find_element_by_xpath("//a[@clstag='shangpin|keycount|product|yanse-复联版']").click()
			time.sleep(5)
			driver.find_element_by_xpath("//a[@clstag='shangpin|keycount|product|yanse-8GB 256GB']").click()
			time.sleep(5)   #会切换页面，所以等2s
			driver.find_element_by_xpath("//a[@clstag='shangpin|keycount|product|btn1-立即预约-yuyue']").click()
			time.sleep(5)
			#driver.find_element_by_class_name('login-tab login-tab-r').click()
			#driver.find_element_by_xpath("//a[@clstag='pageclick|keycount|login_pc_201804112|10']").click()
			driver.find_element_by_xpath("//*[@id='content']/div[2]/div[1]/div/div[3]").click()
			driver.find_element_by_id('loginname').send_keys('18860419700')
			driver.find_element_by_id('nloginpwd').send_keys('taishanbeidou97')
			#driver.find_element_by_class_name('btn-img btn-entry').click()
			driver.find_element_by_xpath("//*[@id='loginsubmit']").click()
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
