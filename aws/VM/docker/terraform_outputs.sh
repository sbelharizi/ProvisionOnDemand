#!/bin/bash

export TF_VAR_POD_COMMON_EXTERNAL_IP=$(terraform output public_ip)
