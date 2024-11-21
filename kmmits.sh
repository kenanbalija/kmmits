#!/bin/bash

# Configure your branch name if not using 'main' or 'master'
BRANCH_NAME="main"

# Create or clear the commits.txt file
echo "" > commits.txt

# Calculate the start and end dates
end_date=$(date +%Y-%m-%d)
start_date=$(date -v -3y -j -f "%Y-%m-%d" "$end_date" +"%Y-%m-%d")

current_date=$start_date

while [ "$current_date" != "$end_date" ]; do
  echo "Creating 1 commit on $current_date"

  # Generate a random time for the commit
  random_hour=$(( RANDOM % 24 ))
  random_minute=$(( RANDOM % 60 ))
  random_second=$(( RANDOM % 60 ))
  commit_time=$(printf "%02d:%02d:%02d" $random_hour $random_minute $random_second)
  commit_date="$current_date $commit_time"

  # Set the environment variables for commit date
  export GIT_AUTHOR_DATE="$commit_date"
  export GIT_COMMITTER_DATE="$commit_date"

  # Make a trivial change
  echo "Commit on $commit_date" >> commits.txt

  # Stage and commit the change
  git add commits.txt
  git commit -m "Commit on $commit_date"

  # Move to the next day
  current_date=$(date -j -v +1d -f "%Y-%m-%d" "$current_date" +"%Y-%m-%d")
done

# Push the commits to the repository
git push origin $BRANCH_NAME
