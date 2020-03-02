#!/bin/bash
#SBATCH --job-name=
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4096
#SBATCH --cpus-per-task=1

source $HOME/virtualenvs/venv/bin/activate
python $HOME/solve.py
