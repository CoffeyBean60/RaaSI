# Judge v0.1 - db.py
# Author: Ryan Cobb (@cobbr_io)
# Project Home: https://github.com/cobbr/Judge
# License: GNU GPLv3

import sqlite3, yaml

# Database functions
def database_create():
    """
    Create the backend ../data/judge.db sqlite database
    """
    db = database_connect()
    with open('../data/schema.sql', mode='r') as f:
        db.cursor().executescript(f.read())
    db.commit()

def database_populate(services_filename):
    """
    Populate the database with default data.
    """
    db = database_connect()
    with open(services_filename, mode='r') as yaml_config:
        cfg = yaml.load(yaml_config)
#    for team in cfg['teams']:
#        execute_db_query('insert into team(team_name) VALUES(?)', [team['team_name']])
    for service in cfg['services']:

        execute_db_query('insert into service(service_type_id, service_name, service_connection, service_request,service_type_name) '
        +'VALUES((select service_type_id from service_type where service_type_name = ?),?,?,?,?)'
        , [service['service_type_name'], service['service_name'], service['service_connection'], service['service_request'],service['service_type_name']])
    for deployment in cfg['deployments']:
        execute_db_query('insert into deployment(service_id, service_name, deployment_name, deployment_device, deployment_percentage) '
        +'VALUES((select service_id from service where service_name = ?),?,?,?,?', [deployment['service_name'], deployment['service_name'], deployment['deployment_name'], deployment['deployment_device'], deployment['deployment_percentage']])

def database_connect():
    """
    Connect with the backend ./judge.db sqlite database and return the
    connection object.
    """
    try:
        conn = sqlite3.connect('../data/judge.db')
        conn.row_factory = sqlite3.Row
        return conn
    except Exception as e:
        print("Error connecting to database. Must run 'flask setup' prior to running. Error message: " + repr(e))
        sys.exit()

def execute_db_query(query, args=None):
    """
    Execute the supplied query on the provided db conn object
    with optional args for a paramaterized query.
    """
    conn = database_connect()
    cur = conn.cursor()
    if(args):
        cur.execute(query, args)
    else:
        cur.execute(query)
    conn.commit()
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results
