#!/bin/bash

export TF_VAR_POD_AWS_PUBLIC_IP=$(terraform output public_ip)

