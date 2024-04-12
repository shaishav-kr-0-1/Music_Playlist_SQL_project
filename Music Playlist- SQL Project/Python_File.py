
from sqlalchemy import create_engine
import pandas as pd


host = 'localhost'
port = '3306'
database = 'Music_Playlist'
username = 'root'
password = 'vincenzo' 

connection_string = f'mysql+pymysql://{username}:{password}@{host}:{port}/{database}'

engine = create_engine(connection_string)
files = ['album','artist','customer','employee','genre','invoice','invoice_line','media_type','playlist','playlist_track','track']
for file in files:
    df = pd.read_csv(f'{file}.csv')
    df.to_sql(f'{file}', con=engine, if_exists='replace', index=False)