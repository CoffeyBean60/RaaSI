# Judge v0.1 - tasks.py
# Author: Ryan Cobb (@cobbr_io)
# Project Home: https://github.com/cobbr/Judge
# License: GNU GPLv3

from celery import Celery
from celery.exceptions import SoftTimeLimitExceeded

# Import utility libraries for various poller services
from urllib.parse import urlparse
from ftplib import FTP
import dns.resolver, requests, difflib, poplib
from dns.exception import DNSException
from io import StringIO
from smtplib import SMTP
import os.path
import os
from time import sleep
import pycurl
from io import BytesIO

from db import execute_db_query

#b_obj = BytesIO()
#crl = pycurl.Curl()
#crl.setopt(crl.URL, "http://MON.sparky.tech")
#crl.setopt(crl.WRITEDATA, b_obj)
app = Celery('tasks', broker='amqp://')
app.config_from_object('config')

s = requests.session()
timeout = app.conf['POLL_TIMEOUT']
	

def curlWeb(ip,string,http):
	if scan_port(ip,'80',[]):
		print("starting curl")
		crl.perform()
		print("curl preformed")
		crl.close()
		get_body = b_obj.getvalue()
		if string in get_body.decode('iso-8859-1').lower():
			flag = True
		else:
			flag = False
		return flag
	else:
		return False

def deploy(deployment):
	os.system('../../Configuration/manuallyDeploy.sh %s %s %s' % (deployment['deployment_name'], deployment['deployment_device'], deployment['deployment_percentage']))
	return
	
def halt(deployment):
	os.system('../../Configuration/manuallyHalt.sh %s' % (deployment['deployment_name']))
	return

def poll():
    """
    Iterates over all the active services in the database and attempt to execute that service's functionality. The success or failure of the service and any error messages are stored in the database.
    """
    for service in execute_db_query('select * from service where service_active = 1'):
        sleep(2)
        # Grab the service from the database
        row = execute_db_query('select * from service_type join service ON (service_type.service_type_id = service.service_type_id) where service.service_type_id = ?', [service['service_type_id']])[0]
        if row:
            type = row['service_type_name']
            # Perform DNS Request
            if type == 'dns':
                poll_dns(timeout, service['service_id'], service['service_connection'], service['service_request'], service['service_running'])
            # Perform HTTP(S) Request
            elif type == 'http' or type == 'https':
                poll_web(timeout, service['service_id'], row['service_type_name'], service['service_connection'], service['service_request'], service['service_running'],type)
            # Perform FTP Request
            elif type == 'ftp':
                poll_ftp(timeout, service['service_id'], service['service_connection'], service['service_request'])
            # Perform SMTP request to send mail, POP3 to retrieve it back
            elif type == 'mail':
                poll_mail(timeout, service['service_id'], service['service_connection'], service['service_request'])
           

@app.task(soft_time_limit=6)
def poll_dns(poll_timeout, service_id, service_connection, service_request):
	print("poll dns")
	# get deployments associated with service through service_id
	#deployments = execute_db_query('select * from deployment where service_id = ?', [service_id])
	#check if the service is running
	# if running
		# if running state is set to 0
			# execute halt on all deployments attached
			# change running state to 1
	# if not running
		# if running state is set to 1
			# execute deployment on all deployments attached
			# change running state to 0
	#print('at dns')
	#if scan_port(service_connection,'53',[]):
        #        print('connected')
        #        print(service_connection)
        #        for team in execute_db_query('select * from team'):
        #        	execute_db_query('insert into poll(poll_score, service_id, team_id, service_type_name) values(1,?,?,?)', [service_id,team['team_id'],'dns'])
	#else:
        #        print('not connected')
        #        print(service_connection)
        #        execute_db_query('insert into poll(poll_score, service_id, service_type_name) values(1,?,?)', [service_id,'dns'])


@app.task(soft_time_limit=6)
def poll_web(poll_timeout, service_id, service_type, service_connection, service_request, service_running, type1):
	deployments = execute_db_query('select * from deployment where service_id = ?', [service_id])
	try:
	   try:
	      try:
	         result = s.get(service_type + '://' + service_connection, timeout=poll_timeout, verify=False).text
	      except requests.exception.Timeout as e:
	         execute_db_query('insert into error(service_id, error_message) values(?,?)', [service_id, 'HTTP(S) Request resulted in a Timeout exception: ' + repr(e)])
	         if service_running == 1:
	         	# execute deployment
	         	for deployment in deployments:
	         		deploy(deployment)
	         	execute_db_query('update service set service_running = 0 where service_id = ?', [service_id])
	         return
	      except requests.exception.ConnectionError as e:
	         execute_db_query('insert into error(service_id, error_message) values(?,?)', [service_id, 'HTTP(S) Request resulted in a ConnectionError exception: ' + repr(e)])
	         if service_running == 1:
	         	# execute deployment
	         	for deployment in deployments:
	         		deploy(deployment)
	         	execute_db_query('update service set service_running = 0 where service_id = ?', [service_id])
	         return
	      except requests.exception.HTTPError as e:
	         execute_db_query('insert into error(service_id, error_message) values(?,?)', [service_id, 'HTTP(S) Request resulted in a HTTPError exception: ' + repr(e)])
	         if service_running == 1:
	         	# execute deployment
	         	for deployment in deployments:
	         		deploy(deployment)
	         	execute_db_query('update service set service_running = 0 where service_id = ?', [service_id])
	         return
	      except requests.exception.TooManyRedirects as e:
	         execute_db_query('insert into error(service_id, error_message) values(?,?)', [service_id, 'HTTP(S) Request resulted in a TooManyRedirects exception: ' + repr(e)])
	         if service_running == 1:
	         	# execute deployment
	         	for deployment in deployments:
	         		deploy(deployment)
	         	execute_db_query('update service set service_running = 0 where service_id = ?', [service_id])
	         return
	      except requests.exception.RequestException as e:
	         execute_db_query('insert into error(service_id, error_message) values(?,?)', [service_id, 'HTTP(S) Request resulted in a RequestException exception: ' + repr(e)])
	         if service_running == 1:
	         	# execute deployment
	         	for deployment in deployments:
	         		deploy(deployment)
	         	execute_db_query('update service set service_running = 0 where service_id = ?', [service_id])
	         return
	      match = False
	      for team in execute_db_query('select * from team'):
	         if service_request in result:
	         	if service_running == 0:
	         		# execute halt
	         		for deployment in deployments:
	         			halt(deployment)
	         		execute_db_query('update service set service_running = 1 where service_id = ?', [service_id])
	         		match = True
	         		break
	      if not match:
	         if service_running == 1:
	         	# execute deployment
	         	for deployment in deployments:
	         		deploy(deployment)
	         	execute_db_query('update service set service_running = 0 where service_id = ?', [service_id])
	   except Exception as e:
	      execute_db_query('insert into error(service_id, error_message) values(?,?)', [service_id, 'HTTP(S) Request resulted in exception: ' + repr(e)])
	      if service_running == 1:
	      	 # execute deployment
	         for deployment in deployments:
	         	deploy(deployment)
	         execute_db_query('update service set service_running = 0 where service_id = ?', [service_id])
	      pass
	except SoftTimeLimitExceeded:
	   execute_db_query('insert into error(service_id, error_message) values(?,?)', [service_id, 'HTTP(S) Request resulted in exception: ' + repr(e)])
	   if service_running == 1:
	         # execute deployment
	         for deployment in deployments:
	         	deploy(deployment)
	         execute_db_query('update service set service_running = 0 where service_id = ?', [service_id])
#	if curlWeb(service_connection,service_request,'http'):
#                for team in execute_db_query('select * from team'):
#                	execute_db_query('insert into poll(poll_score, service_id, team_id, service_type_name) values(1,?,?,?)', [service_id,team['team_id'],type1])
#	else:
#		execute_db_query('insert into poll(poll_score, service_id, service_type_name) values(1,?,?)', [service_id,type1])
		
	
# TODO: improved exception handling for FTP
@app.task(soft_time_limit=6)
def poll_ftp(poll_timeout, service_id, service_connection, service_request):
	print("poll ftp")
	#if scan_port(service_connection,'21',[]):
        #        for team in execute_db_query('select * from team'):
        #        	execute_db_query('insert into poll(poll_score, service_id, team_id, service_type_name) values(1,?,?,?)', [service_id,team['team_id'],'ftp'])
	#else:
	#	execute_db_query('insert into poll(poll_score, service_id, service_type_name) values(1,?,?)', [service_id,'ftp'])
	
	
@app.task(soft_time_limit=6)
def poll_db(poll_timeout, service_id, service_connection, service_request):
	print("poll db")
	#if scan_port(service_connection,'5432',[]):
        #        for team in execute_db_query('select * from team'):
        #        	execute_db_query('insert into poll(poll_score, service_id, team_id, service_type_name) values(1,?,?,?)', [service_id,team['team_id'],'db'])
	#else:
	#	execute_db_query('insert into poll(poll_score, service_id, service_type_name) values(1,?,?)', [service_id,'db'])
		

# TODO: Improved exception handling for mail
@app.task(soft_time_limit=6)
def poll_mail(poll_timeout, service_id, service_connection, service_request):
	print("poll mail")
	#print('entering mail')
	#try:
	#	data = dns.resolver.query(service_connection, dns.rdatatype.A)
	#except:
	#	print('dns did not resolve')
	#	execute_db_query('insert into poll(poll_score, service_id, service_type_name) values(1,?,?)', [service_id,'mail'])
	#	return
	#for item in data:
	#	service_connection = str(item)
	#try:
	#	match = False
	#	try:
	#		print('sending mail to: ', service_connection)
	#		smtpServer=SMTP(service_connection,timeout=(poll_timeout*2))
	#		print('here')
	#		smtp_headers = smtpServer.helo(service_connection)
	#		print('here1')
	#		for team in execute_db_query('select * from team'):
	#			actual = smtp_headers[1].lower()
	#			team_name = team['team_name'].lower()
	#			print(actual)
	#			print(team_name)
				#print(smtp_headers[1].lower())
				#print(team['team_name'])
	#			if str(team_name) in str(actual):
	#				print('herheheh')
	#				execute_db_query('insert into poll(poll_score, service_id, team_id, service_type_name) values(1,?,?,?)', [service_id,team['team_id'],'mail'])
	#				match = True
	#				break
	#	except Exception as e:
	#		execute_db_query('insert into error(service_id, error_message) values(?,?)', [service_id, 'SMTP Request resulted in exception: ' + repr(e)])
	#		execute_db_query('insert into poll(poll_score, service_id, service_type_name) values(0,?,?)', [service_id,'mail'])
	#		return
	#	if not match:
	#		execute_db_query('insert into poll(poll_score, service_id, service_type_name) values(1,?,?)', [service_id,'mail'])
	#except SoftTimeLimiteExceeded:
	#	execute_db_query('insert into error(service_id, error_message) values(?,?)', [service_id, 'Task timed out. No error message received.'])
	#	execute_db_query('insert into poll(poll_score,service_id,service_type_name) values(1,?,?)', [service_id,'mail'])
	#if scan_port(service_connection,'25',[]):
        #        for team in execute_db_query('select * from team'):
        #        	execute_db_query('insert into poll(poll_score, service_id, team_id, service_type_name) values(1,?,?,?)', [service_id,team['team_id'],'mail'])
	#else:
	#	execute_db_query('insert into poll(poll_score, service_id, service_type_name) values(1,?,?)', [service_id,'mail'])
		

