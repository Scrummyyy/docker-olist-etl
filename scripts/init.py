import os
os.environ['PGCLIENTENCODING'] = 'utf-8'

from config import *

import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(db_url)

df = pd.read_sql_query("SELECT * FROM olist_sellers LIMIT 10;", con=engine)
print(df.head())



