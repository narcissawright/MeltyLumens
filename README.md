# MeltyLumens
A Cardano native asset.  
Paid to people who do well in the MELTY BLOOD: TYPE LUMINA tournaments held in Narcissa's Castle Reborn discord server :)

Mainly uploading this for "posterity" but if you're interested in minting on Cardano then you can do so by following these steps:
- fully sync a node 
- edit create_new_token_mainnet.sh with your preferred parameters (testnet vs mainnet, custom asset name, custom policy)
- run create_new_token_mainnet.sh
- fund the address (for paying for txs and sending assets)
- edit mint_token_mainnet.sh with your preferred parameters (amount paid, to whom)
- edit metadata.json (or omit it from mint_token_mainnet.sh)
- run mint_token_mainnet.sh
