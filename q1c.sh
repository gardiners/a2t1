#!/bin/bash

awk -F $'\t' '$3 ~ /(Purine biosynthesis)|(Pyrimidine biosynthesis)/' annotation.tsv