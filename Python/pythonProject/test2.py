import pandas as pd

# Creating a simple DataFrame
data = {
    'Name': ['John', 'Jane', 'Paul', 'Mary', 'Anna'],
    'Age': [28, 34, 29, 40, 23],
    'City': ['New York', 'Chicago', 'Los Angeles', 'Chicago', 'New York']
}

df = pd.DataFrame(data)

# Displaying the DataFrame
print("Original DataFrame:")
print(df)

# Filtering: Select people who are 30 or older
filtered_df = df[df['Age'] >= 30]

# Aggregation: Get the average age
average_age = df['Age'].mean()

print("\nFiltered DataFrame (Age >= 30):")
print(filtered_df)

print("\nAverage Age:", average_age)
