import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

def clean_dataset(file_path):

    df = pd.read_csv('online_sales_dataset.csv')

    #print(df.head())
    #print(df.info())
    #print(df.describe(include='all'))

    # Check for nulls
    #print(df.isnull().sum())

    # Clean CustomerID on nulls
    df = df.dropna(subset=['CustomerID'])

    # Input median for ShippingCost
    df['ShippingCost'] = df.groupby('ShipmentProvider')['ShippingCost'].transform(lambda x: x.fillna(x.median()))

    # Shipping location, we use mode
    mode_warehouse = df['WarehouseLocation'].mode()[0]
    df['WarehouseLocation'] = df['WarehouseLocation'].fillna(mode_warehouse)

    # Check for nulls
    #print(df.isnull().sum())

    # Format InvoiceDate to date data type
    df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'])

    # Create column for total of purchase
    df['TotalRevenue'] = df['Quantity'] * df['UnitPrice']

    #print(df.head())

    # Filter for negatives or 0
    df = df[df['Quantity'] > 0]
    df = df[df['UnitPrice'] > 0]

    # Return the dataframe
    return df


def get_db_engine():
    # String for creating the engine
    user = os.getenv('DB_USER')
    password = os.getenv('DB_PASS')
    host = os.getenv('DB_HOST')
    port = os.getenv('DB_PORT')
    db = os.getenv('DB_NAME')

    # Return the engine
    return create_engine(f'postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}')


def load_into_sql(df, engine):
    table_name = 'sales_data'
    df.to_sql(table_name, engine, if_exists='replace', index=False)
    
    print(f'Data succesfully loaded into PostgreSQL')


if __name__ == "__main__":
    clean_df = clean_dataset('online_sales_dataset.csv')
    engine = get_db_engine()
    load_into_sql(clean_df, engine)
