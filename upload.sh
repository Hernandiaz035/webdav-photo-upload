#!/bin/ash

CONFIG_FILE="config.txt"

USERNAME=$(grep -i username $CONFIG_FILE | awk -F '=' '{print $2}')
PASSWORD=$(grep -i password $CONFIG_FILE | awk -F '=' '{print $2}')
URL=$(grep -i url $CONFIG_FILE | awk -F '=' '{print $2}')

find_images() {
  find /mnt/ -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) | sort -n | grep -v "/\."
}

hash_filenames() {
  find_images | while read -r line; do
    md5=$(echo -n "$line" | md5sum | awk '{print $1}')
    echo $md5 $line
  done > /tmp/tmp_hashes.txt
}

get_hash_history() {
  cat ~/hashes.txt
}

# returns only the files that are in /tmp/tmp_hashes.txt but not in ~/hashes.txt
get_new_files() {
  cat /tmp/tmp_hashes.txt | while read -r line; do
    hash=$(echo -n "$line" | awk '{print $1}')
    if ! grep -q "$hash" ~/hashes.txt; then
      echo "$line"
    fi
  done
}

upload_file() {
  file=$(echo -n "$1" | awk '{$1=""; print}' | sed 's/^ *//')
  curl -k -X PUT -u $USERNAME:$PASSWORD $URL/$USERNAME/ -T \"$file\"
}

# create a function to upload a list of files using curl
upload_files() {
  echo "List of new files:"
  get_new_files
  echo "=================="
  get_new_files | while read -r line; do
    echo "uploading $line....."
    upload_file "$line"
  done
  get_new_files >> ~/hashes.txt
  echo "Done!"
}

# execute the functions
hash_filenames
upload_files
