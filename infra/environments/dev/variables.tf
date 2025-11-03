variable "region" { 
    type = string  
    default = "us-east-1" 
}

variable "tags"   { 
    type = map(string) 
    default = { 
        Project = "nyk-demo"
        Env = "dev"
        Owner = "Juan" } 
}
