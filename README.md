# Hyperion Setup and Install

## Setup Instructions

1. Clone this repo into /opt/
    
    Then cd into the directory

2. Run ```sudo ./install.sh```

    This will prompt you to restart the system upon completing. `MUST` restart before continuing.
    Once the system has rebooted, connect to the server again and ```cd /opt/hyperion-docker-new```

    NOTE: check inside hyperion-history-api and ensure that you see a node_modules folder, if not cd into hyperion-history-api and run ```npm i```

3. We will now update configs to work with your chain 

    a. hyperion > config > ```connections.json```: update "wire" settings in the "chains" object.
        
        1. name - set this to your chains name
        2. chain_id - set this to match your chain's chain id, should be located in YOUR chain's genesis.json
    
    b. hyperion > config > chains> ```wire.config.json```

        This file effects swagger docs and other hyperion configs. Can leave most of this alone.

        Under "api" set "custom_core_token" to whatever your network's core token symbol is.

        Under "indexer", depending on your scenario can set "rewrite" to true if you want it to reindex on each start up. For development networks this could be useful.

    c. nodeos > wire > config > ```config.ini```

        At the bottom p2p-peer-address, set this to an RPC for your network.

    d. nodeos > wire > config > ```genesis.json```

        Replace this with your chain's genesis.json

4. Now ```cd /opt/hyperion-docker-new``` and run ```sudo ./init.sh``` 

    This will create the hyperion docker group

5. We can now start all our containers.

    a. First we will start up our nodeos process Run ```sudo ./start_nodeos.sh```

    You can check the logs to make sure you're nodeos process is syncing run ```docker logs -f wire-node``` press ctrl + C to get out of following the logs.

    b. Now we will start up infra Run ```sudo ./start_infra.sh```

    You can run ```docker logs -f infra-es01-1``` to watch the logs.

    c. And finally we will start up Hyperion Run ```sudo ./start_hyperion.sh```

    You can run ```docker logs -f hyperion-indexer-1``` you should see logs of it beginning to index the chain.

    NOTE: If you see pm2 messages and no indexing, double check that the ```hyperion-history-api``` directory has a ```node_modules```
