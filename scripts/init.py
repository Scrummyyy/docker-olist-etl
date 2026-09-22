
##import libraries
import os
from datetime import datetime
import pandas as pd
from sqlalchemy import create_engine

## import local server set up info
from config import *

## Take month from env variable
TARGET_DATE = os.getenv("TARGET_DATE", '2018-08-06')

## Define engine for working with local postgres server
engine = create_engine(db_url)

## Read datasets for target period
olist_orders = pd.read_sql_query(f"SELECT * FROM olist_orders\
                                 WHERE DATE(order_estimated_delivery_date) = '{TARGET_DATE}'; ", con=engine)

## Create dataframe with delayed orders
olist_overdue_orders = olist_orders[olist_orders['order_estimated_delivery_date'] < olist_orders['order_delivered_customer_date']]

olist_overdue_orders['amount_overdue_days'] = olist_orders['order_delivered_customer_date'] - olist_orders['order_estimated_delivery_date']

print(olist_overdue_orders['amount_overdue_days'])


