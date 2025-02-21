# Submission Reminder App

A basic application that alerts students about upcoming assignment deadlines.

## Prerequisites

- Bash shell
- Linux environment
- Git (for cloning repository)
- Python version 3.*

## Installation

```bash
# Clone the repository
git clone https://github.com/Masalale/submission_reminder_app_masalale.git

# Navigate to the directory
cd submission_reminder_app_masalale

# Make the setup script executable
chmod +x create_environment.sh

# Run the setup script
./create_environment.sh
```

## Usage

```bash
# Navigate to your personalized reminder directory
cd submission_reminder_<yourname>

# Start the application
./startup.sh
```

## File Structure

```plaintext
submission_reminder_<yourname>/
├── app/
│   └── reminder.sh        # Main reminder application logic
├── modules/
│   └── functions.sh       # Helper functions and utilities
├── assets/
│   └── submissions.txt    # Student submission records
├── config/
│   └── config.env        # Environment configuration
└── startup.sh            # Application entry point
```

## Script Explanations

### Below is a breakdown of the scripts:

#### create_environment.sh  
- Sets up the initial directory structure  
- Creates necessary subdirectories and files  
- Configures file permissions  
- Takes user input for personalization

#### startup.sh  
- Serves as the entry point for the application  
- Validates required files and dependencies  
- Sources configuration and functions  
- Launches the reminder system

#### reminder.sh  
- Processes submission status  
- Displays reminders for pending submissions  
- Reads data from submissions.txt  
- Utilizes configurations from config.env

#### functions.sh  
- Contains core functionality for submission checking  
- Implements various utility functions  
- Handles data processing tasks

## Configuration

The `config.env` file contains:
```bash
ASSIGNMENT="Shell Navigation"    # Current assignment being tracked
DAYS_REMAINING=2                # Days until submission deadline
```

## Error Handling

The application handles common errors:
- Missing files or directories
- Invalid user input
- Configuration issues
- File permission problems