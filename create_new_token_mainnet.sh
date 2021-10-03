newtokenname="MeltyLumens"
export CARDANO_NODE_SOCKET_PATH="/home/narcissa/Desktop/cardano-node/db_main/node.socket"

# Make token directory
mkdir $newtokenname
cd $newtokenname/

# Build payment keys/address
cardano-cli address key-gen --verification-key-file payment.vkey --signing-key-file payment.skey
cardano-cli address build --payment-verification-key-file payment.vkey --out-file payment.addr --mainnet
address=$(cat payment.addr)

# Make protocol file
cardano-cli query protocol-parameters --mainnet --out-file protocol.json

# Make policy directory and keys
mkdir policy
cardano-cli address key-gen \
    --verification-key-file policy/policy.vkey \
    --signing-key-file policy/policy.skey
    
# Create policy
touch policy/policy.script && echo "" > policy/policy.script

echo "{" >> policy/policy.script
echo "  \"type\": \"all\"," >> policy/policy.script 
echo "  \"scripts\":" >> policy/policy.script 
echo "  [" >> policy/policy.script 
echo "   {" >> policy/policy.script 
echo "     \"type\": \"before\"," >> policy/policy.script 
echo "     \"slot\": 1500000000" >> policy/policy.script
echo "   }," >> policy/policy.script 
echo "   {" >> policy/policy.script
echo "     \"type\": \"sig\"," >> policy/policy.script 
echo "     \"keyHash\": \"$(cardano-cli address key-hash --payment-verification-key-file policy/policy.vkey)\"" >> policy/policy.script 
echo "   }" >> policy/policy.script
echo "  ]" >> policy/policy.script 
echo "}" >> policy/policy.script

# Generate policyid
cardano-cli transaction policyid --script-file ./policy/policy.script >> policy/policyID

# Now fund the address, then run the mint script.
echo "Fund me!" $address
