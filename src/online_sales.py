import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

load_dotenv(encoding='utf-8')

def clean_dataset(file_path):

    df = pd.read_csv(file_path)

    print(f"Loaded Dataset: {df.shape[0]} rows, {df.shape[1]} columns\n")

    #print(df.head())
    #print(df.info())
    #print(df.describe(include='all'))

    # Check for nulls
    #print(df.isnull().sum())

    # Clean CustomerID on nulls
    df = df.dropna(subset=['CustomerID'])
    print("Cleaned nulls on column 'CustomerID'")

    # Input median for ShippingCost
    df['ShippingCost'] = df.groupby('ShipmentProvider')['ShippingCost'].transform(lambda x: x.fillna(x.median()))
    print("Transformed empty 'ShippingCost' to median")

    # Shipping location, we use mode
    mode_warehouse = df['WarehouseLocation'].mode()[0]
    df['WarehouseLocation'] = df['WarehouseLocation'].fillna(mode_warehouse)
    print("Filled 'WarehouseLocation' with the mode")

    # Check for nulls
    #print(df.isnull().sum())

    # Format InvoiceDate to date data type
    df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'])
    df['Time'] = df['InvoiceDate'].dt.time
    df['InvoiceDate'] = df['InvoiceDate'].dt.date
    print("Converted 'InvoiceDate' to date_time and separated 'Time' into another column")

    # Typos
    # This don't have issues
    #print(df['Description'].unique())
    #print(df['Country'].unique())
    #print(df['Category'].unique())
    #print(df['SalesChannel'].unique())
    #print(df['ReturnStatus'].unique())
    #print(df['ShipmentProvider'].unique())
    #print(df['WarehouseLocation'].unique())
    #print(df['OrderPriority'].unique())

    # Payment methods has a typo
    #print(df['PaymentMethod'].unique())

    cleanup_map = {
        'paypall': 'PayPal'
    }

    df['PaymentMethod'] = df['PaymentMethod'].replace(cleanup_map)
    
    #print(df['PaymentMethod'].unique())
    print("Changed typo on 'PaymentMethod'")

    # Currency cleaning for 'UnitPrice', 'ShippingCost' and 'Discount'
    df['UnitPrice'] = pd.to_numeric(df['UnitPrice'])
    df['ShippingCost'] = pd.to_numeric(df['ShippingCost'])
    df['Discount'] = pd.to_numeric(df['Discount'])
    print("Converted 'UnitPrice', 'ShippingCost' and 'Discount' to numeric")

    # Create column for total of purchase
    df['TotalRevenue'] = df['Quantity'] * df['UnitPrice']
    print("Created column 'TotalRevenue'")

    #print(df.head())

    # Filter for negatives or 0
    df = df[df['Quantity'] > 0]
    df = df[df['UnitPrice'] > 0]
    print("Filtered negatives on 'Quantity' and 'UnitPrice'")

    print()

    print("Final info on dataframe")
    print(df.info())
    print()

    # Return the dataframe
    return df


def get_db_engine():
    # String for creating the engine
    user = os.getenv('DB_USER')
    password = os.getenv('DB_PASS')
    host = os.getenv('DB_HOST')
    port = os.getenv('DB_PORT')
    db = os.getenv('DB_NAME')

    print("Database Connection")
    print(f"User: {user}, Port: {port}\n")

    # Return the engine
    return create_engine(f'postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}')


def load_into_sql(df, engine):
    
    # We name the table, no need for a variable, but it looks cool
    table_name = 'sales_data'
    df.to_sql(table_name, engine, if_exists='replace', index=False)
    
    print(f'Data succesfully loaded into PostgreSQL')


if __name__ == "__main__":
    
    clean_df = clean_dataset('./data/online_sales_dataset.csv')
    print("Cleaned DataFrame\n")

    # Convert df to csv just in case
    clean_df.to_csv('./data/cleaned_online_sales_dataset.csv', index=False)
    print("CSV file created as './data/cleaned_online_sales_dataset.csv'\n")

    engine = get_db_engine()

    load_into_sql(clean_df, engine)
