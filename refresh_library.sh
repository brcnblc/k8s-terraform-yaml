#!/bin/bash
# Refreshes library content with latest kubernets api library
terraform init
terraform providers schema -json | jq . > provider.json 
python prepare.py