# Hyperion Setup and Install

## Setup Instructions

1. Clone this repo into `/opt/` and after run `cd hyperion-docker-new`.
2. Run install command:

    ```sh
    sudo ./install.sh
    ```

    This will prompt you to restart the system upon completing and you **must** restart before continuing.
    Once the system has rebooted, connect to the server again.

3. Update your chain config

    a. hyperion > config > `connections.json`: update `wire` settings in the `chains` object.

    - `name` - set this to your chains name
    - `chain_id` - `curl <CHAIN_API_RPC>/v1/chain/get_info | jq .`

    b. hyperion > config > chains> ```wire.config.json```

    This file affects swagger docs and other hyperion configs, most likely there isn't anything to be tweaked or change there except:

    - Under `api` set `custom_core_token` to whatever your network's core token symbol is.

    - Under `indexer`, depending on your scenario can set `rewrite` to *true* if you want it to reindex on each start up which is useful for development networks.

    c. nodeop > wire > config > `config.ini`

    - `p2p-peer-address` - set this to an RPC for your network.

    d. nodeop > wire > config > ```genesis.json```

    - Replace this with your chain's genesis.json

4. Create `hyperion` network:

     ```sh
     cd /opt/hyperion-docker-new
     sudo ./init.sh
     ```

5. Start all containers in a **sequential** order:

    a. Start `nodeop`

    - First we will start up our `nodeop` process by running ```sudo ./start_nodeop.sh```

      - You can check the logs to make sure that `nodeop` is syncing:  run ```docker logs -f wire-node``` press *ctrl + C* to get out of following the logs.

    b. Setup infra containers(elasticsearch, kibana, redis)

     ```sh
     sudo ./start_infra.sh
     ```

     - You can run ```docker logs -f infra-es01-1``` to watch the logs.
     - Inspect Kibana port on `http://localhost:5601` - there you can create different indices of the data and run query commands.

       - Default user: `elastic`
       - Password: `changeme123`

    c. Start up Hyperion

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
