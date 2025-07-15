#!/bin/bash

API_KEY="52d66539-9ccd-44d4-818b-e40dc3213a8f"
CACHE_FILE="/tmp/crypto_prices_cache.json"
CACHE_DURATION=300 # 5 minutes

format_price() {
    local price=$1
    if (( $(echo "$price >= 1000" | bc -l) )); then
        printf "%.1fk" $(echo "$price / 1000" | bc -l)
    else
        printf "%.2f" $price
    fi
}

fetch_and_cache_prices() {
    local response=$(curl -s -H "X-CMC_PRO_API_KEY: $API_KEY" -H "Accept: application/json" -G https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest --data-urlencode "symbol=BTC,ETH,SOL")
    echo "$response" > "$CACHE_FILE"
}

get_formatted_price() {
    local symbol=$1
    local price=$(grep -oP "\"$symbol\":{[^}]*\"price\":\K[^,]*" "$CACHE_FILE")
    if [ -z "$price" ] || [ "$price" == "null" ]; then
        echo "$symbol: Error"
    else
        formatted_price=$(format_price $price)
        echo "$symbol: \$$formatted_price"
    fi
}

update_cache_if_needed() {
    if [ ! -f "$CACHE_FILE" ] || [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -ge $CACHE_DURATION ]; then
        fetch_and_cache_prices
    fi
}

display_prices() {
    update_cache_if_needed

    local btc=$(get_formatted_price "BTC")
    local eth=$(get_formatted_price "ETH")
    local sol=$(get_formatted_price "SOL")

    local cycle=$(($(date +%s) % 3))
    case $cycle in
        0) current="$btc" ;;
        1) current="$eth" ;;
        2) current="$sol" ;;
    esac

    echo "{\"text\": \"$current\", \"tooltip\": \"$btc | $eth | $sol\"}"
}

display_prices
