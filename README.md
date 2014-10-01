# cryptsy-public-api

## Description

**cryptsy-public-api** is an Emacs library for working with the Cryptsy public
API. Cryptsy is an exchange for a variety of crypto-currencies, include BitCoin,
LiteCoin and Dogecoin.

It's not a particularly useful extension on its own, but can be used to build
something more interesting.


## Installation

All Emacs installs are a little different, but the basic outline is this:

- Download the source code and put it somewhere Emacs can find it (probably
    `~/.emacs.d/`)
    
- Add that directory to your load-path if it’s not yet there:
```lisp
(add-to-list 'load-path "/path/to/dir")
```
 
- Add `(require 'cryptsy-public-api)` somewhere in Emacs initialization file.


## Usage

The two main functions in the API are:

### cryptsy-public-api-get-market-data

**cryptsy-public-api-get-market-data** is used to fetch gneral market data. It
can be called either with a `market-id`, or with `:all` to fetch all market
data.

This will return a JSON object containing the market information, along with
recent buy orders, sell orders and recent trades.

The following example fetches the current value of BTC in USD:

```lisp
(defun get-info-node (response type)
  (assoc-default type (assoc-default 'markets (assoc-default 'return response))))

(let ((response (cryptsy-public-api-get-market-data 2)))
  (assoc-default 'lasttradeprice (get-info-node response 'BTC)))
```

**WARNING** : Fetching all market data is extremely slow and memory intensive as
the data is around 20MiB. It is not recommended.


### cryptsy-public-api-get-orderbook-data

**cryptsy-public-api-get-orderbook-data** is used for fetching order book
data. As with **cryptsy-public-api-get-market-data** it can accept a `market-id`
parameter for narrowing down the return value.

The response is similar to **cryptsy-public-api-get-market-data** except it does
not contain recent trades.

----

For more information on the public API, see the official documentation:

https://www.cryptsy.com/pages/publicapi

*There are no interactive functions as part of this library.*


## Helpers

The library also provides several helper functions to make it easier to extract
information from the JSON responses.

### cryptsy-public-api-get-info-value

Takes a currency identifier, field name and JSON response and returns the
value. The earlier example for fetching a currency's value can be rewritten as:

```lisp
(let ((response (cryptsy-public-api-get-market-data 2)))
  (cryptsy-public-api-get-info-value 'BTC 'lasttradeprice contents))
```

The following field names can be used:

 - `marketid` - The market's ID which can be used when querying the API
 - `label` - The full label of the market, such as "DOGE/USD"
 - `primarycode` - The market's primary code, such as BTC or DOGE
 - `primaryname` - The full name of the primary market
 - `secondarycode` - The market's secondary code, such as USD
 - `secondaryname` - The market's secondary name
 - `lasttradetime` - The last time a trade was made
 - `volume` - The total volume of trades in the last 24 hours
 - `lasttradeprice` - The last trade price on this market


### cryptsy-public-api-get-buy-orders

Takes a currency identifier and JSON response and returns a `vector` of buy
orders. Each buy order consists of three fields:

 - `total` - The total value of the order
 - `quantity` - The number of currency items bought
 - `price` - The price per unit


### cryptsy-public-api-get-sell-orders

Takes a currency identifier and JSON response and returns a `vector` of sell
orders. Each sell order consists of three fields:

 - `total` - The total value of the order
 - `quantity` - The number of currency items sold
 - `price` - The price per unit


## Things That Use This Library

- dogecoin-ticker-mode


## Licence

Copyright (C) 2014 Phil Newton

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
Street, Fifth Floor, Boston, MA 02110-1301, USA.
