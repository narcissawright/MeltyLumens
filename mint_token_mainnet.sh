# You need to edit the mintamount
# the winneraddr
# and if used, the metadata.json
# and then you can run this script to mint.

mintamount="20"
winneraddr="addrxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
assetname="MeltyLumens"
cd $assetname/
export CARDANO_NODE_SOCKET_PATH="/home/narcissa/Desktop/cardano-node/db_main/node.socket"
address=$(cat payment.addr)

queryresult=$(cardano-cli query utxo --address $address --mainnet)
echo "${queryresult}" > queryresult.txt
IFS=' '
thirdline=`sed -n '3p' queryresult.txt`;
read -r -a strarr <<< $thirdline
txhash=${strarr[0]}
txix=${strarr[1]}
funds=${strarr[2]}
policyid=$(cat policy/policyID)

output="0"
fee="300000"
adasent="1500000"
slotnumber="1500000000"

# place this as one of the params if you want metadata.
# don't forget to build the metadata first!
#  --metadata-json-file metadata.json \

cardano-cli transaction build-raw \
  --fee $fee \
  --tx-in $txhash#$txix \
  --tx-out $address+$output \
  --tx-out $winneraddr+$adasent+"$mintamount $policyid.$assetname" \
  --mint="$mintamount $policyid.$assetname" \
  --minting-script-file policy/policy.script \
  --invalid-hereafter $slotnumber \
  --metadata-json-file metadata.json \
  --out-file matx.raw

fee=$(cardano-cli transaction calculate-min-fee --tx-body-file matx.raw --tx-in-count 1 --tx-out-count 1 --witness-count 1 --mainnet --protocol-params-file protocol.json | cut -d " " -f1)
output=$(expr $funds - $fee - $adasent)

cardano-cli transaction build-raw \
  --fee $fee \
  --tx-in $txhash#$txix \
  --tx-out $address+$output \
  --tx-out $winneraddr+$adasent+"$mintamount $policyid.$assetname" \
  --mint="$mintamount $policyid.$assetname" \
  --minting-script-file policy/policy.script \
  --invalid-hereafter $slotnumber \
  --metadata-json-file metadata.json \
  --out-file matx.raw

cardano-cli transaction sign  \
--signing-key-file payment.skey  \
--signing-key-file policy/policy.skey  \
--mainnet --tx-body-file matx.raw  \
--out-file matx.signed

cardano-cli transaction submit --tx-file matx.signed --mainnet
