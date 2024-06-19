echo "Snapshot description: "
read description
snapper --config root create --read-write --description $description