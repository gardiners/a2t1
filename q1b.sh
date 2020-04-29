#!/bin/bash

awk -F $'\t' '$2 ~ /ase/' annotation.tsv