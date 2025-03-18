# Hyperion Setup

## Setup Instructions

1. Clone and enter this repo `git clone https://github.com/Wire-Network/hyperion-docker-new && cd hyperion-docker-new`.

2. Configure Environment Variables
    ```
    cp .env.template .env
    nano .env
    ```
    
Edit the .env file to provide appropriate values for your setup.

3. Install dependencies:

    ```sh
    sudo ./prepare.sh
    ```

4. Update Configuration files:
   
    a. `hyperion > config > connections.json`: update `wire` settings in the `chains` object. Here you will configure a connection to a Wire API node where the state history plugin (SHIP) is enabled and accessable via websocket. You can either run this wire nodeop container alongisde this hyperion stack, or simply reference an external API node with available state history plugin (default port 8080 via ws://).

    - `name` - set this to your chains name
    - `chain_id` - Chain ID string of the wire chain you are configuring. Retrieve with `/v1/chain/get_info > chain_id`
    - `http` - Standard Chain API Url (typically port 8888)
    - `ship` - State History Plugin websocket endpoint (typically port 8080 via ws://)

    b. `hyperion > config > chains > wire.config.json`

    This file affects swagger docs and other hyperion configs, most likely there isn't anything to be tweaked or change there except:

    - `api > custom_core_token` to whatever your network's core token symbol is. Default is SYS
    - `api > server_name`: for the swagger code samples, instead of using <IP>:<port> format which attaches HTTPS in the beggining and breaks the code sample
    - `api > server_addr`: set to 0.0.0.0 - the value for the server that hosts the Hyperion indexer, which also provides the API. Since both are on the same machine, it is localhost.
    - `indexer > rewrite` to *true* if you want it to reindex on each start up which is useful for development networks.
    - As you get deeper into hyperion configurations, you can explore tweaking the indexer configs and beyond.
      
    <br>
    
   > At this point, if you have a healthy node with available state history plugin and do not wish to use this docker stack's nodeop container as your chain ingestor, you can skip to step 4. Otherwise, continue with c and d to configure Wire chain-api peering node container.
   
    c. `nodeop > wire > config > config.ini`

    - `p2p-peer-address` - set least 1 RPC peering address for your network 

    d. `nodeop > wire > config > genesis.json`

    - Replace this with your chain's genesis.json retrieved from your genesis node

5. Create new local docker network called `hyperion`:

     ```sh
     sudo ./init.sh
     ```

6. Start each container group **in sequential order**: (nodeop > infra > hyperion)

    a. Optional - if you are using this stack's wire nodeop container for ingesting:

    - Start up our `nodeop` process by running:

    ```sh
    `sudo ./start_nodeop.sh`
    ```
    
    - Check the logs to make sure that `nodeop` is syncing with your network: run ```docker logs -f wire-node``` press *ctrl + C* to get out of following the logs.
    - This is essentially just a wire chain-api node peering with your network and serving chain data via websocket to your hyperion indexer container.
    > Wait for your nodeop container to sync fully with your network before continuing.

    b. Setup infrastructure containers (elasticsearch, kibana, redis, etc)

     ```sh
     sudo ./start_infra.sh
     ```

     - Then run ```docker logs -f infra-es01-1``` to watch the logs.
    > Wait for shard status to change from [RED] to [GREEN] before continuing.

    c. Start up Hyperion Indexer & API containers

     ```sh
     sudo ./start_hyperion.sh
     ```

     - You can run ```docker logs -f hyperion-indexer-1``` you should see logs of it beginning to index the chain.

If everything was setup correctly when inspecting logs of `hyperion-api-1` container you should see:

```log
@timestamp [TAILING] Tailing last 10 lines for [wire-api] process (change the value with --lines option)
@timestamp /root/.pm2/logs/wire-api-out.log last 10 lines:
@timestamp /root/.pm2/logs/wire-api-error.log last 10 lines:
@timestamp: [26 - 00_master] --------- Hyperion API 3.3.10 ---------
@timestamp: [26 - 00_master] Chain API URL: <chain-api-url> | Push API URL: "undefined"
@timestamp: Importing stream module...
@timestamp: [26 - 00_master] [SocketManager] chain_id: d06acae4e2ae21346cd7cffb820cd06eb1ad2b9f37303b3c2a4d93c2841cb31a
@timestamp: [26 - 00_master] Socket.IO via uWS started on port 1234
@timestamp: [26 - 00_master] Websocket manager loaded!
@timestamp: [26 - 00_master] starting relay - http://127.0.0.1:7001
@timestamp: [26 - 00_master] Last commit hash on this branch is: 9f0b276a12f6c29c695fc5750b4fb4fabd71bf01
@timestamp: [26 - 00_master] Chain API validated!
@timestamp: [26 - 00_master] Elasticsearch: 8.7.1 | Lucene: 9.5.0
@timestamp: [26 - 00_master] Elasticsearch validated!
@timestamp: [26 - 00_master] Registering plugins...
@timestamp: [26 - 00_master] wire Hyperion API ready and listening on http://0.0.0.0:7000
```

Your Hyperion History API should now be available at http://<IP>:7000/v2/health. 
Also, check out the Swaggar OpenAPI spec docs at this url: http://<IP>:7000/v2/docs

Healthy example for Wire Testnet: [https://testnet-hyperion.wire.foundation/v2/health](https://testnet-hyperion.wire.foundation/v2/health) / [https://testnet-hyperion.wire.foundation/v2/docs](https://testnet-hyperion.wire.foundation/v2/docs)

## Resources

- [Chain config example](https://hyperion.docs.eosrio.io/providers/setup/chain/?h=chain#example)

## Troubleshooting

### `wire-node` not syncing/starting

- verify that you've updated `genesis.json` in `nodeop/wire/config`
- ensure you have modified `chain_id` in `hyperion/config/chains/wire.config.json`  - `curl <CHAIN_API_RPC>/v1/chain/get_info | jq .chain_id`
- you have cleared the contents of  `nodeop/data` before starting `wire-node` container

### `wire-node` not peering

**Error messages:**

```sh
error 2024-12-03T19:03:04.763 net-1     net_plugin.cpp:2355           operator()           ] connection failed to 0.0.0.0:0 Connection refused
error 2024-12-03T19:03:04.763 net-4     net_plugin.cpp:2355           operator()           ] connection failed to 0.0.0.0:0 
```

**Solution**: Verify you have at least **one valid** `p2p-peer-address` declared in `nodeop/wire/config/config.ini`

## License

[FSL-1.1-Apache-2.0](./LICENSE.md)
