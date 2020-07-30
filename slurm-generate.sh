#!/bin/bash
#SBATCH --job-name=shortest-path
#SBATCH --time=01:00:00
#SBATCH --mem=1024
#SBATCH --output=shortest-path-%A-%a.out
#SBATCH --error=shortest-path-%A-%a.out
​
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
​
# Launch an array job using e.g.
#
#    sbatch --array=1-6%2 job.sh
#
# This queues 6 jobs with at most 2 running simultaneously.
​
echo "Job $SLURM_ARRAY_JOB_ID $SLURM_ARRAY_TASK_ID"
for i in {1..10}   # Or some suitably large number?
do
    python generate.py [args] | bin/sp-algorithm
done
​
# Alternatively could make this an infinite loop and wait for the job
# to timeout, but I'm not sure if there are consequences to doing that
# all the time.
