#!/bin/bash
# A shell script named that sets up the directory structure for an application called submission_reminder_app

# Validate user input
validate_name() {
    local name=$1
    if [[ ! $name =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
        echo "Error: Name must start with a letter and contain only letters, numbers, underscores, or hyphens"
        exit 1
    fi
}

# Get user input with validation
# -p flag allows displaying a prompt message
# The input is stored in the variable user_name
read -p "Please enter your name: " user_name
validate_name "$user_name"

# Uses mkdir to create a directory with the user_name
# -p flag prevents errors if directory already exists
main_dir="submission_reminder_$user_name"
mkdir -p "$main_dir"

# Once the directory is created the following subdirectories and files will be inside it
mkdir -p "$main_dir"/{app,modules,assets,config}

# Create reminder.sh in the app subdirectory with execute permissions
cat > "$main_dir/app/reminder.sh" << 'EOL'
#!/bin/bash

# Store the directory path where this script is located
main_dir=$(dirname "$0")
# The parent directory of 'app'
parent_dir="$(dirname "$main_dir")"

# Source environment variables and helper functions from parent directories
source "$parent_dir/config/config.env" || { echo "Failed to load config"; exit 1; }
source "$parent_dir/modules/functions.sh" || { echo "Failed to load functions"; exit 1; }

# Path to the submissions file from parent directory
submissions_file="$parent_dir/assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "$submissions_file"
EOL

# Make the reminder.sh executable
chmod +x "$main_dir/app/reminder.sh"

# Create submission.txt with default content in the assets subdirectory
cat > "$main_dir/assets/submissions.txt" << 'EOL'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
EOL

# Concatenate 5 new student records to submissions.txt
cat >> "$main_dir/assets/submissions.txt" << 'EOL'
Ngash, Git Basics, not submitted
Brian, Shell Navigation, submitted
Winnie, Shell Basics, not submitted
Cindy, Git, submitted
Nikki, Shell Navigation, not submitted
EOL

# Create config.env in the config subdirectory
cat > "$main_dir/config/config.env" << 'EOL'
# This is the config file
ASSIGNMENT=${ASSIGNMENT:-"Shell Navigation"}
DAYS_REMAINING=2
EOL

# Create functions.sh in the modules subdirectory
cat > "$main_dir/modules/functions.sh" << 'EOL'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"
    echo "--------------------------------------------"

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

EOL

# Make functions.sh executable
chmod +x "$main_dir/modules/functions.sh"

# Create startup.sh in the root directory and make it executable
cat > "$main_dir/startup.sh" << 'EOL'
#!/bin/bash

# Store the directory path where this script is located
main_dir=$(dirname "$0")

# Define an array of critical files that must exist for the application to run
required_files=(
    "$main_dir/config/config.env"
    "$main_dir/modules/functions.sh"
    "$main_dir/assets/submissions.txt"
)

# Validate existence of all required files
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: $(basename "$file") not found!"
        exit 1
    fi
done

# Source helper functions
source "$main_dir/modules/functions.sh" || handle_error "Failed to load functions"

# Prompt user for assignment selection
echo "Please select an assignment:"
echo "1) Shell Navigation (default)"
echo "2) Git"
echo "3) Shell Basics"
read -p "Enter your choice (1-3) [1]: " choice

# Set ASSIGNMENT based on user selection
# Default to 1 if no choice is made (empty input)
choice=${choice:-1}

case $choice in
    1)
        ASSIGNMENT="Shell Navigation"
        ;;
    2)
        ASSIGNMENT="Git"
        ;;
    3)
        ASSIGNMENT="Shell Basics"
        ;;
    *)
        echo "Invalid selection. Please choose 1, 2, or 3."
        exit 1
        ;;
esac

# Export the user-selected ASSIGNMENT
export ASSIGNMENT

# Source config.env; it uses default expansion so ASSIGNMENT remains unchanged
source "$main_dir/config/config.env" || handle_error "Failed to load config"

# Verify DAYS_REMAINING is set
if [[ -z "${DAYS_REMAINING}" ]]; then
    echo "Configuration Error: Please ensure DAYS_REMAINING variable is properly set in config.env file"
    exit 1
fi

echo "--------------------------------------------"

# Launch the main reminder application
"$main_dir/app/reminder.sh"

exit 0
EOL

# Make startup.sh executable
chmod +x "$main_dir/startup.sh"