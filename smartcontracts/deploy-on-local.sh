forge b --skip test script --build-info

forge script script/deployInfiniToken.s.sol:InfiniTokenScript \
    --rpc-url http://127.0.0.1:8545 \
    --build-info \
    --broadcast \
    --verbosity \
    --private-key $PRIVATE_KEY

python deploy.py

