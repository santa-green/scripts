@Grab(group='org.postgresql', module='postgresql', version='42.2.24')
@Grab(group='software.amazon.awssdk', module='secretsmanager', version='2.17.51')

import groovy.sql.Sql
import groovy.json.JsonSlurper
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueRequest
import software.amazon.awssdk.services.secretsmanager.model.SecretsManagerException


// Load the PostgreSQL driver explicitly
this.class.classLoader.rootLoader.addURL(new URL("https://jdbc.postgresql.org/download/postgresql-42.2.24.jar"))


def getSecret() {
    def secretName = "rds!db-1dfd41e5-78d1-409e-a54e-1c142cd658d8"
    def client = SecretsManagerClient.builder().region(Region.EU_NORTH_1).build()

    try {
        def request = GetSecretValueRequest.builder().secretId(secretName).build()
        def response = client.getSecretValue(request)

        if (response.secretString() != null) {
            return response.secretString()
        }
    } catch (SecretsManagerException e) {
        throw new RuntimeException("Error fetching secret: ${e.getMessage()}")
    }
}

def getCredentials() {
    def secret = getSecret()
    def credentialsDict = new JsonSlurper().parseText(secret)

    def hostname = "db-instance-pg1.c1nyoxqqdwsz.eu-north-1.rds.amazonaws.com"
    def port = 5432
    def database = "db_test_pg1"

    def credentials = [
        hostname: hostname,
        port: port,
        database: database,
        username: credentialsDict.username,
        password: credentialsDict.password
    ]
    return credentials
}

def sqlExec() {
    def credentials = getCredentials()
    def sql = Sql.newInstance(
        "jdbc:postgresql://${credentials.hostname}:${credentials.port}/${credentials.database}",
        credentials.username,
        credentials.password
    )

    try {
        def result = sql.firstRow("SELECT version();")
        println("You are connected to - ${result}\n")
        sql.execute("INSERT INTO test_s3_copy SELECT * FROM test_s3 WHERE id NOT IN (SELECT id FROM test_s3_copy);")
        sql.close()
        println("[i] Status: SUCCESS")
    } catch (Exception e) {
        println("Error while working with PostgreSQL: ${e.getMessage()}")
        println("[x] Status: FAILURE")
        sql.rollback()
    } finally {
        sql.close()
        println("PostgreSQL connection is closed")
    }
}

sqlExec()