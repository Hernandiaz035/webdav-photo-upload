# WebDAV photo upload
Bash/Ash script to upload all the found images in `/mnt/**`.

# Process
This script perform the following steps:
1. Lists all the images inside all the volumes mounted in `/mnt/`.
1. Hashes all the filenames and stores them in `/tmp/tmp_hashes.txt`.
1. Picks the hashes from step 2 that don't exist in `./hashes.txt`.
1. Performs a `PUT` request with the remaining files from the previous step.
1. If the uploading of the file was successful, the filename and the hash are stored in `./hashes.txt`.

Tested on Nextcloud.
