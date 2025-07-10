import xml.etree.ElementTree as ET
import pandas as pd
from datetime import datetime, timezone

def parse_apple_health_data(file_paths):
    """
    Parses Apple Health XML files to extract sleep analysis data.

    Args:
        file_paths (list): A list of paths to the Apple Health XML files.

    Returns:
        pandas.DataFrame: A DataFrame containing the extracted sleep analysis data.
    """

    sleep_data = []

    for file_path in file_paths:
        tree = ET.parse(file_path)
        root = tree.getroot()

        # Handle different XML structures
        if root.tag == 'ClinicalDocument':
            records = root.findall(".//{urn:hl7-org:v3}observation")
            for record in records:
                code_elem = record.find("{urn:hl7-org:v3}code")
                if code_elem is not None and code_elem.get('code') == 'SLEEP':
                    source_name_elem = record.find(".//{urn:hl7-org:v3}sourceName")
                    source_name = source_name_elem.text if source_name_elem is not None else None
                    start_date = record.find(".//{urn:hl7-org:v3}low").get('value')
                    end_date = record.find(".//{urn:hl7-org:v3}high").get('value')
                    value_elem = record.find(".//{urn:hl7-org:v3}value")
                    value = value_elem.get('code') if value_elem is not None else None

                    sleep_data.append({
                        "sourceName": source_name,
                        "startDate": start_date,
                        "endDate": end_date,
                        "value": value,
                    })

        elif root.tag == 'HealthData':
            records = root.findall("Record[@type='HKCategoryTypeIdentifierSleepAnalysis']")
            for record in records:
                source_name = record.get('sourceName')
                start_date = record.get('startDate')
                end_date = record.get('endDate')
                value = record.get('value')

                sleep_data.append({
                    "sourceName": source_name,
                    "startDate": start_date,
                    "endDate": end_date,
                    "value": value,
                })

    return pd.DataFrame(sleep_data)

def clean_and_format_sleep_data(df):
    """
    Cleans and formats the sleep data DataFrame.

    Args:
        df (pandas.DataFrame): The DataFrame containing sleep analysis data.

    Returns:
        pandas.DataFrame: The cleaned and formatted DataFrame.
    """

    df['startDate'] = pd.to_datetime(df['startDate'], utc=True)
    df['endDate'] = pd.to_datetime(df['endDate'], utc=True)
    return df

def calculate_sleep_metrics(df):
    """
    Calculates sleep metrics from the cleaned sleep data.

    Args:
        df (pandas.DataFrame): The cleaned DataFrame containing sleep analysis data.

    Returns:
        pandas.DataFrame: The DataFrame with calculated sleep metrics.
    """

    df['sleep_duration'] = (df['endDate'] - df['startDate']).dt.total_seconds() / 3600  # in hours

    # Handling potential 'In Bed' records to estimate time to asleep
    df['time_diff_to_next_record'] = df.groupby('sourceName')['startDate'].shift(-1) - df['endDate']

    return df

def analyze_sleep_trends(df):
    """
    Analyzes sleep trends from the DataFrame.

    Args:
        df (pandas.DataFrame): The DataFrame with calculated sleep metrics.
    """

    # Daily total sleep time
    daily_sleep_time = df.groupby(df['startDate'].dt.date)['sleep_duration'].sum()
    print("\nDaily Total Sleep Time (hours):\n", daily_sleep_time)

    # Average sleep duration by source
    avg_sleep_by_source = df.groupby('sourceName')['sleep_duration'].mean()
    print("\nAverage Sleep Duration by Source:\n", avg_sleep_by_source)

    # Distribution of sleep stages
    stage_distribution = df['value'].value_counts(normalize=True) * 100
    print("\nDistribution of Sleep Stages (%):\n", stage_distribution)

    #Find 5 longest sleep sessions
    longest_sleep_sessions = df.sort_values(by='sleep_duration', ascending=False).head(5)
    print("\n5 Longest Sleep Sessions:\n", longest_sleep_sessions)

    # Find 5 shortest sleep sessions
    shortest_sleep_sessions = df.sort_values(by='sleep_duration', ascending=True).head(5)
    print("\n5 Shortest Sleep Sessions:\n", shortest_sleep_sessions)


# Main execution
file_paths = [r'C:\Users\rumiantsev\Downloads\apple_health_export\export_cda.xml', r'C:\Users\rumiantsev\Downloads\apple_health_export\export.xml']  # Replace with your file paths
sleep_df = parse_apple_health_data(file_paths)
sleep_df = clean_and_format_sleep_data(sleep_df)
sleep_df = calculate_sleep_metrics(sleep_df)
analyze_sleep_trends(sleep_df)