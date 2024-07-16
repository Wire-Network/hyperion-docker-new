# Hyperion Setup and Install

## Setup Instructions

1. Clone this repo into /opt/
    
    Then cd into the directory

2. Run ```sudo ./install.sh```

    This will prompt you to restart the system upon completing. `MUST` restart before continuing.
    Once the system has rebooted, connect to the server again and go back to /opt/

3. We will now update configs to work with your chain 

    a. hyperion > config > ```connections.json```: update "wire" settings in the "chains" object.
        
        1. name - set this to your chains name
        2. chain_id - set this to match your chain's chain id, should be located in YOUR chain's genesis.json
    
    b. hyperion > config > chains> ```wire.config.json```

        This file effects swagger docs and other hyperion configs. Can leave most of this alone.

        Under "indexer", depending on your scenario can set "rewrite" to true if you want it to reindex on each start up. For development networks this could be useful.

    c. nodeos > wire > config > ```config.ini```

        At the bottom p2p-peer-address, set this to an RPC for your network.

    d. nodeos > wire > config > ```genesis.json```

        Replace this with your chain's genesis.json