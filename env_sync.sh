 #!/bin/bash

 # Define paths
 ENV_FOLDER="$HOME/envs"

 # Function to sync .env file from ~/envs based on current directory name
 sync_envs() {
     local action="$1"

     # Get the current directory name (project name)
     local current_dir=$(basename "$(pwd)")
     local pwd=$(pwd)

     case "$action" in
         "copy")
             # Copy .env file to ~/envs/projectname/
             if [ ! -d "$ENV_FOLDER/$current_dir" ]; then
                 mkdir -p "$ENV_FOLDER/$current_dir"
             fi
             echo "$current_dir"
             cp "$pwd/".env* "$ENV_FOLDER/$current_dir/"
             echo ".env* files copied to $ENV_FOLDER/$current_dir/"
             # Git operations
             if [ ! -d "$ENV_FOLDER/$current_dir/.git" ]; then
                 git -C "$ENV_FOLDER/$current_dir" init
             fi
             git -C "$ENV_FOLDER/$current_dir" add .env*
             git -C "$ENV_FOLDER/$current_dir" commit -m "Copied .env* files from $pwd to $ENV_FOLDER/$current_dir/ at $(date)"
             ;;
         "move")
             # Move .env file from ~/envs/projectname/ to current directory
             if ls "$ENV_FOLDER/$current_dir/".env* 1> /dev/null 2>&1; then
                 mv "$ENV_FOLDER/$current_dir/".env* ./
                 echo ".env* files moved from $ENV_FOLDER/$current_dir/ to current directory."
                 # Git operations
                 if [ ! -d "$ENV_FOLDER/$current_dir/.git" ]; then
                     git -C "$ENV_FOLDER/$current_dir" init
                 fi
                 git -C "$ENV_FOLDER/$current_dir" add .env*
                 git -C "$ENV_FOLDER/$current_dir" commit -m "Moved .env* files from $ENV_FOLDER/$current_dir/ to $pwd at $(date)"
             else
                 echo "Error: .env* file not found in $ENV_FOLDER/$current_dir/"
                 exit 1
             fi
             ;;
         *)
             echo "Usage: env_sync [copy|move]"
             exit 1
             ;;
     esac
 }

 # Function to copy .env file from ~/envs based on manually provided directory name
 copy_env_by_name() {
     local dir_name="$1"

     # Check if .env file exists in ~/envs/directory_name/
     if ls "$ENV_FOLDER/$dir_name/".env* 1> /dev/null 2>&1; then
         cp "$ENV_FOLDER/$dir_name/".env* ./
         echo ".env* files copied from $ENV_FOLDER/$dir_name/ to current directory."
         # Git operations
         if [ ! -d "$ENV_FOLDER/$dir_name/.git" ]; then
             git -C "$ENV_FOLDER/$dir_name" init
         fi
         git -C "$ENV_FOLDER/$dir_name" add .env*
         git -C "$ENV_FOLDER/$dir_name" commit -m "Copied .env* files from $ENV_FOLDER/$dir_name/ to current directory at $(date)"
     else
         echo "Error: .env* files not found in $ENV_FOLDER/$dir_name/"
     fi
 }

 # Function to list directories in ~/envs
 list_envs_directories() {
     echo "Directories in $ENV_FOLDER:"
     ls -d $ENV_FOLDER/*/ | xargs -n 1 basename
 }

 # Help function
 show_help() {
     echo "Usage: $0 [option]"
     echo "Options:"
     echo "  copy          Copy .env* from current directory to ~/envs/projectname/"
     echo "  move          Move .env* from ~/envs/projectname/ to current directory"
     echo "  ls            List directories in $ENV_FOLDER"
     echo "  get <dir>     Copy .env* from ~/envs/<dir> to current directory"
     echo "  dir <pattern> List directories in $ENV_FOLDER matching <pattern>"
     echo "  --help        Show this help message"
 }

 # Main script logic
 case "$1" in
     "copy")
         sync_envs copy
         ;;
     "move")
         sync_envs move
         ;;
     "ls")
         list_envs_directories
         ;;
     "get")
         if [ -n "$2" ]; then
             copy_env_by_name "$2"
         else
             echo "Error: Please provide a directory name. Usage: env_sync get directory_name"
             exit 1
         fi
         ;;
     "dir")
         if [ -n "$2" ]; then
             list_envs_directories | grep "$2"
         else
             echo "Error: Please provide a directory name to search. Usage: env_sync dir directory_name"
             exit 1
         fi
         ;;
     "--help")
         show_help
         ;;
     *)
         echo "Error: Invalid option. Use '--help' for usage."
         exit 1
         ;;
 esac

