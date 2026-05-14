# vpc module 
this module is develepoed for devops compeny.projects inside joindevops.follows this module to create their vpc.
#inputs
project(required) users should specify a project name
enviornment (required) users specify env
cidr(optional) user provide cidr blocks default is 10.0.0.0/16

# outputs
vpc_id - expose vpc id created
public_subnet_ids