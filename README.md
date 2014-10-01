# cryptsy-public-api

## Description

**cryptsy-public-api** is an Emacs library for working with the Cryptsy public
API. Cryptsy is an exchange for a variety of crypto-currencies, include BitCoin,
LiteCoin and Dogecoin.

It's not a particularly useful extension on its own, but can be used to build
something more interesting.


## Installation

All Emacs installs are a little different, but the basic outline is this:

1. Download the source code and put it somewhere Emacs can find it (probably
    `~/.emacs.d/`)
    
2. Add that directory to your load-path if it’s not yet there:
```lisp
(add-to-list 'load-path "/path/to/dir")
```
 
3. Add `(require 'cryptsy-public-api)` somewhere in Emacs initialization file.


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
