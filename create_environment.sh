#!/bin/bash
# create_environment.sh
# Creates the submission reminder environment automatically

echo "Enter your name:"
read name

BASE_DIR="submission_reminder_${name}"

# Check if directory already exists
if [ -d "$BASE_DIR" ]; then
    echo "Directory $BASE_DIR already exists. Please remove it or use another name."
    exit 1
fi

# Create directory structure
mkdir -p $BASE_DIR/{app,modules,assets,config}

# --------------------------
# Populate reminder.sh
# --------------------------
cat << 'EOF' > $BASE_DIR/app/reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# --------------------------
# Populate functions.sh
# --------------------------
cat << 'EOF' > $BASE_DIR/modules/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# --------------------------
# Populate config.env
# --------------------------
cat << 'EOF' > $BASE_DIR/config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# --------------------------
# Populate submissions.txt (with 5 more students)
# --------------------------
cat << 'EOF' > $BASE_DIR/assets/submissions.txt
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Emmanuel, Shell Navigation, not submitted
Maria, Git, not submitted
Joshua, Shell Navigation, submitted
Tanya, Shell Basics, not submitted
Kabelo, Shell Navigation, not submitted
EOF

# --------------------------
# Create startup.sh
# --------------------------
cat << 'EOF' > $BASE_DIR/startup.sh
#!/bin/bash
# startup.sh - Launch the reminder app

# Navigate to script directory (safety)
cd "$(dirname "$0")"

# Run the reminder app
bash ./app/reminder.sh
EOF

# --------------------------
# Make all shell scripts executable
# --------------------------
find $BASE_DIR -type f -name "*.sh" -exec chmod +x {} \;

echo "Environment created successfully in $BASE_DIR!"
tree $BASE_DIR

