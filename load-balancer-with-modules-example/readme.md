## Setup
1. Install Terraform binary
2. Configure environment variables to allow you to authenticate with AWS API:
* export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
* export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
3. Run terraform plan/apply

## To test service  
Run 
````
curl http://<DNS_NAME>
```` 
or
````
terraform show output instructions
````