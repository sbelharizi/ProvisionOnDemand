#!/bin/bash

export TF_VAR_POD_GCP_EXTERNAL_IP=$(terraform output public_ip)

