# vault-init.sh

# start Vault in background
vault server -config=/vault/config/az-kv-vault-auto-unseal.hcl &
VAULT_PID=$!

# give Vault a few seconds to become responsive
sleep 7

# Initialize Vault
if vault status | grep -q 'Initialized.*false'; then
  echo "Vault is not initialized. Initializing..."
  vault operator init > /unseal-script/unseal-output.txt
else
  echo "Vault is already initialized."
fi

vault status

# wait for the leader to finish initialization and write the token file
sleep 5

# grab the root token
export VAULT_TOKEN=$(grep 'Initial Root Token' /unseal-script/unseal-output.txt | awk '{print $4}')

# persist for all future CLI sessions
mkdir -p "$HOME" && echo "$VAULT_TOKEN" > "$HOME/.vault-token"

vault operator raft list-peers

# now wait for Vault process to exit (or keep running)
wait $VAULT_PID