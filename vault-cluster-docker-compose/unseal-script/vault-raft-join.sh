#!/bin/sh

# Start the Vault server in the background
vault server -config=/vault/config/az-kv-vault-auto-unseal.hcl &
VAULT_PID=$!

# Wait for the server to start
sleep 10

# raft join vault-server1
# no need to decalre the address of the server bacause it is already in the config.hcl file by retry_join parameter
#vault operator raft join http://vault-server1:8200
echo "Joining leader…"


echo "raft joined successfully"

# # initialize if needed and unseal the vault
# if vault status | grep -q 'Initialized.*false'; then
#   echo "Vault is not initialized. Initializing..."
#   vault operator init > /unseal-script/unseal-output.txt
# else
#   echo "Vault is already initialized."
# fi

vault status

# # Wait for the leader to finish initialization and write the token file
# echo "Waiting for root token…"
# while [ ! -f /unseal-script/unseal-output.txt ]; do
#   sleep 1
# done

# grab the root token
export VAULT_TOKEN=$(grep 'Initial Root Token' /unseal-script/unseal-output.txt | awk '{print $4}')

# persist for all future CLI sessions (write into root’s home)
mkdir -p "$HOME" && echo "$VAULT_TOKEN" > "$HOME/.vault-token"

vault operator raft list-peers

# Keep container running & waiting process in the background to finish
wait $VAULT_PID

