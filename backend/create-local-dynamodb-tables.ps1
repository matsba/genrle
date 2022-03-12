$params = "--table-name", "genrle-backend-dev-entities",
    "--attribute-definitions", "AttributeName=PK,AttributeType=S",
    "--key-schema", "AttributeName=PK,KeyType=HASH",
    "--provisioned-throughput", "ReadCapacityUnits=10,WriteCapacityUnits=5",
    "--table-class", "STANDARD",
    "--endpoint-url", "http://localhost:8000"

aws dynamodb create-table @params
