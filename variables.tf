variable "rgname" {
    description = "resource grouop name"
    default     = "BCG_RG_DEV"
}
variable "location" {
    description = "location name"
    default     = "East Us"
}
variable "vnet_name" {
     description = "name for vnet"
     type=string
     default     = "BCG_VNET_DEV"
}
variable "address_space" {
     default     = ["10.1.0.0/16"]
     type        = any
}
variable "subnet_name" {
     default     = "BCG_SUBNET_DEV"
     type=string
}
variable "address_prefix" {
      default     = "10.1.0.0/24"
    type        = string

}
variable "external_ip" {
     type        = list(string)
    default      = ["103.203.172.52"]
 }
 variable "numbercount" {
     type 	  = number
     default       = 2
 } 
 variable "type" {
   description = "(Optional) Defined if the loadbalancer is private or public"
   type        = string
   default     = "public"
 }
 variable "frontend_name" {
   description = "(Required) Specifies the name of the frontend ip configuration."
   type        = string
   default     = "myPublicIP"
 }
 variable "numbercount1" {
     type      = number
    default   = 2
 } 
 variable "frontend_subnet_id" {
   description = "(Optional) Frontend subnet id to use when in private mode"
   type        = string
   default     = ""
 }

 variable "frontend_private_ip_address" {
   description = "(Optional) Private ip address to assign to frontend. Use it with type = private"
   type        = string
   default     = ""
 }

 variable "frontend_private_ip_address_allocation" {
   description = "(Optional) Frontend ip allocation type (Static or Dynamic)"
   type        = string
   default     = "Dynamic"
 }