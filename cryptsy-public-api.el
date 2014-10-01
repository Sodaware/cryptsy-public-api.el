;;; cryptsy-public-api.el --- API library for working with Cryptsy

;; Copyright (C) 2014 Phil Newton

;; Author: Phil Newton <phil@sodaware.net>
;; Version: 1.0.0
;; Package-Requires: ((json "1.2"))
;; Keywords: cryptsy bitcoin litecoin dogecoin

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; cryptsy-public-api provides library functionality for working with the
;; Cryptsy public API.  The public API can be used to query general market
;; information for crypto currencies.

;; There are two main methods:
;;   - cryptsy-public-api-get-market-data
;;   - cryptsy-public-api-get-orderbook-data

;; Leaving off the `market-id' parameter or using `:all' will fetch general
;; information rather than data for a single market.
 
;; For more information on the API, see https://www.cryptsy.com/pages/publicapi

;;; Code:

;; Dependencies

(require 'json)
(require 'url-http)

(defvar url-http-end-of-headers)

;; Configuration

(defgroup cryptsy-public-api nil
  "Cryptsy public api extension"
  :group 'comms
  :prefix "cryptsy-public-api-")

(defconst cryptsy-public-api-endpoint "http://pubapi.cryptsy.com/api.php")

;; Main query methods

(defun cryptsy-public-api-get-market-data (&optional market-id)
  "Fetches market data for MARKET-ID.

Using nil or :all for MARKET-ID will return general data."
  (if (or (null market-id) (eq :all market-id))
      (cryptsy-public-api-get :method "marketdatav2")
    (cryptsy-public-api-get :method "singlemarketdata" :marketid market-id)))

(defun cryptsy-public-api-get-orderbook-data (&optional market-id)
  "Fetches order book data for MARKET-ID.

Using nil or :all for MARKET-ID will return general data."
  (if (or (null market-id) (eq :all market-id))
      (cryptsy-public-api-get :method "orderdatav1")
    (cryptsy-public-api-get :method "singleorderdata" :marketid market-id)))


;; API helpers

(defun cryptsy-public-api-get-info-value (name field response)
  "Get the value of NAME's FIELD from a RESPONSE."
  (assoc-default field (cryptsy-public-api-get-info name response)))

(defun cryptsy-public-api-get-info (name response)
  "Get the informational (none-history) for NAME from a RESPONSE."
  (assoc-default name (assoc-default 'markets (assoc-default 'return response))))

(defun cryptsy-public-api-get (&rest query-vars)
  "Generate a uri using QUERY-VARS and retrieve the result from the API."
  (cryptsy-public-api-get-uri (cryptsy-public-api-create-endpoint query-vars)))

(defun cryptsy-public-api-get-uri (uri)
  "Fetch the contents URI and return as JSON."
  (with-current-buffer (url-retrieve-synchronously uri)
    (goto-char (point-min))
    (goto-char url-http-end-of-headers)
    (prog1 (json-read)
      (kill-buffer))))

(defun cryptsy-public-api-create-endpoint (query-vars)
  "Build an endpoint to the public api using QUERY-VARS."
  (format "%s?%s" cryptsy-public-api-endpoint (cryptsy-public-api-build-query query-vars)))

(defun cryptsy-public-api-build-query (query-vars)
  "Build a query string using QUERY-VARS.

QUERY_VARS should be a list of symbols and their corresponding
values.

For example (:key value :other-key value) will generate
the following string: key=value&other-key=value"
  (let (query-string)

    ;; Build the query string
    (dolist (var query-vars)
      (if (symbolp var)
          (setq query-string (concat query-string (substring (symbol-name var) 1) "="))
        (setq query-string (format "%s%s&" query-string var))))
    
    ;; Trim the trailing ampersand
    (substring query-string 0 -1)))

(provide 'cryptsy-public-api)
;;; cryptsy-public-api.el ends here
