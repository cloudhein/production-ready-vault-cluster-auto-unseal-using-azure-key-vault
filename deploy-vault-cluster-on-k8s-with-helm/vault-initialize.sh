#!/bin/sh
set -e

# Variables
VAULT_POD_0="vault-0"
VAULT_POD_1="vault-1"
VAULT_POD_2="vault-2"
NAMESPACE="vault"
UNSEAL_FILE="unseal.json"

# 1. Initialize Vault if it’s not already initialized
echo "Checking Vault initialization status on ${VAULT_POD_0}..."
if kubectl exec -i "${VAULT_POD_0}" -n "${NAMESPACE}" -- vault status | grep -q 'Initialized.*false'; then
  echo "Vault is not initialized. Initializing now..."
  kubectl exec -i "${VAULT_POD_0}" -n "${NAMESPACE}" -- vault operator init -format=json > "${UNSEAL_FILE}"
  echo "Initialization complete. Output saved to ${UNSEAL_FILE}."
else
  echo "Vault is already initialized."
fi

# Small delay to ensure Vault has written out its raft config
sleep 10

# 2. Join the other nodes into the Raft cluster
echo "Joining ${VAULT_POD_1} to raft cluster at ${VAULT_POD_0}..."
kubectl exec -i "${VAULT_POD_1}" -n "${NAMESPACE}" -- vault operator raft join "http://${VAULT_POD_0}.vault-internal:8200"

sleep 3

echo "Joining ${VAULT_POD_2} to raft cluster at ${VAULT_POD_0}..."
kubectl exec -i "${VAULT_POD_2}" -n "${NAMESPACE}" -- vault operator raft join "http://${VAULT_POD_0}.vault-internal:8200"

echo "All nodes have been instructed to join the raft cluster."
