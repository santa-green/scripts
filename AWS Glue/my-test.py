import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglueml.transforms import EntityDetector
from awsgluedq.transforms import EvaluateDataQuality

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Default ruleset used by all target nodes with data quality enabled
DEFAULT_DATA_QUALITY_RULESET = """
    Rules = [
        ColumnCount > 0
    ]
"""

# Script generated for node Amazon S3
AmazonS3_node1753970356787 = glueContext.create_dynamic_frame.from_options(format_options={"multiLine": "false"}, connection_type="s3", format="json", connection_options={"paths": ["s3://dataset-national-baby-names/subset10-set-national-baby-names.json"], "recurse": True}, transformation_ctx="AmazonS3_node1753970356787")

# Script generated for node Detect Sensitive Data
detection_parameters = {
  "IRELAND_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "POLAND_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NORWAY_BIRTH_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "JAPAN_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_NATIONAL_DRUG_CODE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CANADA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "DENMARK_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SLOVAKIA_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "HUNGARY_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ROMANIA_NUMERICAL_PERSONAL_CODE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "THAILAND_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "AUSTRALIA_COMPANY_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CROATIA_IDENTITY_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BELGIUM_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "DENMARK_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "KOREA_RESIDENCE_REGISTRATION_NUMBER_FOR_FOREIGNERS": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "GREECE_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SPAIN_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "IRELAND_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "AUSTRIA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MALAYSIA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_HCPCS_CODE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FINLAND_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "AUSTRALIA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MEXICO_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SLOVENIA_UNIQUE_MASTER_CITIZEN_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MALTA_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MALTA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "PORTUGAL_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BRAZIL_NATURAL_PERSON_REGISTRY_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "INDIA_PERMANENT_ACCOUNT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NEW_ZEALAND_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MACEDONIA_UNIQUE_MASTER_CITIZEN_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LIECHTENSTEIN_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "PORTUGAL_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SPAIN_BANK_ACCOUNT": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FINLAND_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ESTONIA_PERSONAL_IDENTIFICATION_CODE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SLOVENIA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "KOREA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MALTA_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NETHERLANDS_CITIZEN_SERVICE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SERBIA_UNIQUE_MASTER_CITIZEN_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SPAIN_SSN": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UKRAINE_INDIVIDUAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SPAIN_NIE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SPAIN_NIF": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_ITIN": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SLOVENIA_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ROMANIA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NETHERLANDS_BANK_ACCOUNT": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UK_NATIONAL_INSURANCE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BELGIUM_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SWEDEN_PERSONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BRAZIL_BANK_ACCOUNT": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SWEDEN_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UK_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BANK_ACCOUNT": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "HUNGARY_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CHINA_MAINLAND_TRAVEL_PERMIT_ID_HONG_KONG_MACAU": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "GERMANY_PERSONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "POLAND_REGON_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "DENMARK_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ITALY_FISCAL_CODE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LUXEMBOURG_NATIONAL_INDIVIDUAL_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "JAPAN_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "IRELAND_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FINLAND_HEALTH_INSURANCE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "KOREA_RESIDENCE_REGISTRATION_NUMBER_FOR_CITIZENS": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "EMAIL": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CROATIA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MAC_ADDRESS": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SWEDEN_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SLOVENIA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ESTONIA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "HUNGARY_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LITHUANIA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FRANCE_BANK_ACCOUNT": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "POLAND_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CYPRUS_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SPAIN_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NEW_ZEALAND_NATIONAL_HEALTH_INDEX_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LATVIA_PERSONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MACAU_RESIDENT_IDENTITY_CARD": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UK_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "AUSTRIA_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BELGIUM_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UK_PHONE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MALAYSIA_MYKAD_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CHINA_MAINLAND_TRAVEL_PERMIT_ID_TAIWAN": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "PORTUGAL_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "GREECE_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "IRELAND_PERSONAL_PUBLIC_SERVICE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CANADA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "VENEZUELA_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CZECHIA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_NATIONAL_PROVIDER_IDENTIFIER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NEW_ZEALAND_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NORWAY_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_SSN": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UK_ELECTORAL_ROLL_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SWITZERLAND_AHV": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "VENEZUELA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ROMANIA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MEXICO_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UKRAINE_PASSPORT_NUMBER_INTERNATIONAL": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CYPRUS_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "PHILIPPINES_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FRANCE_HEALTH_INSURANCE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "COLOMBIA_PERSONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CHINA_PHONE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ITALY_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "AUSTRALIA_MEDICARE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LUXEMBOURG_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NETHERLANDS_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "INDONESIA_IDENTITY_CARD_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SOUTH_AFRICA_PERSONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BELGIUM_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UK_BANK_SORT_CODE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ICELAND_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NETHERLANDS_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "GERMANY_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SLOVAKIA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CHINA_LICENSE_PLATE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ICELAND_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "THAILAND_PERSONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "POLAND_SSN": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LUXEMBOURG_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_HEALTH_INSURANCE_CLAIM_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CROATIA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "PORTUGAL_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ICELAND_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CANADA_SOCIAL_INSURANCE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BRAZIL_NATIONAL_REGISTRY_OF_LEGAL_ENTITIES_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CHINA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "TURKEY_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FRANCE_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LATVIA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "TURKEY_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SRI_LANKA_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NETHERLANDS_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CROATIA_PERSONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LITHUANIA_PERSONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "PORTUGAL_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_PTIN": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FRANCE_INSEE_CODE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SWITZERLAND_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ESTONIA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "PHILIPPINES_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "PHONE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "GREECE_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BULGARIA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FINLAND_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "GERMANY_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "HUNGARY_SSN": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ARGENTINA_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "GREECE_SSN": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BULGARIA_UNIFORM_CIVIL_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "POLAND_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SLOVAKIA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CYPRUS_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CYPRUS_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SINGAPORE_UNIQUE_ENTITY_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UKRAINE_PASSPORT_NUMBER_DOMESTIC": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BOSNIA_UNIQUE_MASTER_CITIZEN_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_ATIN": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_MEDICARE_BENEFICIARY_IDENTIFIER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "HONG_KONG_IDENTITY_CARD": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MEXICO_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LUXEMBOURG_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SINGAPORE_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SPAIN_DNI": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NORWAY_HEALTH_INSURANCE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "AUSTRALIA_BUSINESS_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "TAIWAN_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CREDIT_CARD": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "AUSTRIA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FRANCE_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LIECHTENSTEIN_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_DEA_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SWITZERLAND_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "AUSTRIA_SSN": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MEXICO_UNIQUE_POPULATION_REGISTRY_CODE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FRANCE_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ITALY_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CYPRUS_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "TAIWAN_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "IRELAND_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "PERSON_NAME": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FRANCE_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LATVIA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "JAPAN_BANK_ACCOUNT": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LIECHTENSTEIN_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "INDIA_AADHAAR_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "GERMANY_BANK_ACCOUNT": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "POLAND_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CZECHIA_PERSONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LITHUANIA_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CANADA_GOVERNMENT_IDENTIFICATION_CARD_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SLOVAKIA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SERBIA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NETHERLANDS_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SWITZERLAND_HEALTH_INSURANCE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BULGARIA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LATVIA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FINLAND_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CZECHIA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "TURKEY_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "AUSTRALIA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "POLAND_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BRAZIL_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "DENMARK_PERSONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "COLOMBIA_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "GERMANY_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "AUSTRALIA_TAX_FILE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "VOJVODINA_UNIQUE_MASTER_CITIZEN_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ROMANIA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NORWAY_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LUXEMBOURG_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ITALY_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UK_UNIQUE_TAXPAYER_REFERENCE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CANADA_PERSONAL_HEALTH_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "FRANCE_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "GERMANY_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CHILE_NATIONAL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SINGAPORE_NATIONAL_REGISTRY_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UNITED_ARAB_EMIRATES_PERSONAL_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "BELGIUM_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "JAPAN_MY_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "HUNGARY_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SWEDEN_TAX_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CHILE_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SWEDEN_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MEXICO_CLABE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SPAIN_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "KOSOVO_UNIQUE_MASTER_CITIZEN_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "AUSTRIA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SLOVENIA_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "VENEZUELA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CANADA_PERMANENT_RESIDENCE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MALTA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "LITHUANIA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "GREECE_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "SINGAPORE_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "NORWAY_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "MONTENEGRO_UNIQUE_MASTER_CITIZEN_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "CHINA_IDENTIFICATION": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "USA_DRIVING_LICENSE": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ITALY_BANK_ACCOUNT": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ESTONIA_VALUE_ADDED_TAX": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UK_NATIONAL_HEALTH_SERVICE_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "ISRAEL_IDENTIFICATION_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "IP_ADDRESS": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UK_PASSPORT_NUMBER": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }],
  "UK_BANK_ACCOUNT": [{
    "action": "PARTIAL_REDACT",
    "actionOptions": {
      "numLeftCharsToExclude": "2",
      "redactChar": "*"
    }
  }]
}

entity_detector = EntityDetector()
DetectSensitiveData_node1753973741703 = entity_detector.detect(AmazonS3_node1753970356787, detection_parameters, "DetectedEntities", "HIGH")

# REMOVE DetectedEntities from each record in your DynamicFrame
def drop_detected_entities(rec):
    rec = rec.copy()
    rec.pop("DetectedEntities", None)
    return rec

# Apply to your DynamicFrame
redacted_no_entities = DetectSensitiveData_node1753973741703.map(drop_detected_entities)


# Script generated for node Amazon S3
EvaluateDataQuality().process_rows(frame=redacted_no_entities, ruleset=DEFAULT_DATA_QUALITY_RULESET, publishing_options={"dataQualityEvaluationContext": "EvaluateDataQuality_node1753977219486", "enableDataQualityResultsPublishing": True}, additional_options={"dataQualityResultsPublishing.strategy": "BEST_EFFORT", "observations.scope": "ALL"})
AmazonS3_node1753979732026 = glueContext.write_dynamic_frame.from_options(frame=redacted_no_entities, connection_type="s3", format="json", connection_options={"path": "s3://dataset-national-baby-names-redacted", "partitionKeys": []}, transformation_ctx="AmazonS3_node1753979732026")

job.commit()