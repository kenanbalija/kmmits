#!/bin/bash

# Configure your branch name if not using 'main' or 'master'
BRANCH_NAME="main"

# Create or clear the commits.txt file
echo "" > commits.txt

# Calculate the start and end dates

# Get today's date in YYYY-MM-DD format
end_date=$(date +"%Y-%m-%d")

# Calculate the date 3 years ago
# For macOS (BSD date):
start_date=$(date -j -v -3y -f "%Y-%m-%d" "$end_date" +"%Y-%m-%d")
# For Linux (GNU date), you can use:
# start_date=$(date -d "$end_date - 3 years" +"%Y-%m-%d")

current_date=$start_date

while [ "$current_date" != "$end_date" ]; do
  # Generate a random number of commits between 1 and 10
  num_commits=$(( ( RANDOM % 10 ) + 1 ))  # Generates a number between 1 and 10

  echo "Creating $num_commits commits on $current_date"

  for ((i=1; i<=num_commits; i++)); do
    # Generate a random time for the commit
    random_hour=$(( RANDOM % 24 ))
    random_minute=$(( RANDOM % 60 ))
    random_second=$(( RANDOM % 60 ))
    commit_time=$(printf "%02d:%02d:%02d" $random_hour $random_minute $random_second)
    commit_date="$current_date $commit_time"
    echo "Commit date is: $commit_date"

    # Set the environment variables for commit date
    export GIT_AUTHOR_DATE="$commit_date"
    export GIT_COMMITTER_DATE="$commit_date"

    # Make a trivial change
    echo "Commit number $i on $commit_date" >> commits.txt

    # Stage and commit the change
    git add commits.txt
    git commit -m "Commit number $i on $commit_date"
  done

  # Move to the next day

  # For macOS (BSD date):
  current_date=$(date -j -v +1d -f "%Y-%m-%d" "$current_date" +"%Y-%m-%d")
  # For Linux (GNU date), you can use:
  # current_date=$(date -d "$current_date + 1 day" +"%Y-%m-%d")
done

# Push the commits to the repository
git push origin $BRANCH_NAME
