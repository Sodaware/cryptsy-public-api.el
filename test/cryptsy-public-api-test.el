(ert-deftest cryptsy-public-api-test/can-create-endpoint ()
  (should (string=
           "http://pubapi.cryptsy.com/api.php?method=singlemarketdata&marketid=182"
           (cryptsy-public-api--create-endpoint (list :method "singlemarketdata"
                                                     :marketid 182)))))

(ert-deftest cryptsy-public-api-test/can-build-query ()
  (should (string=
           "method=singlemarketdata&marketid=182"
           (cryptsy-public-api--build-query (list :method "singlemarketdata"
                                                 :marketid 182)))))

(ert-deftest cryptsy-public-api-test/can-get-named-value ()
  (let ((contents (read-fixture "singlemarketdata-marketid-182.json")))
    (should (string= "DOGE"
                     (cryptsy-public-api-get-info-value 'DOGE 'primarycode contents)))))

(ert-deftest cryptsy-public-api-test/can-get-buy-orders ()
  (with-mock
   (mock-request (:method "singlemarketdata" :marketid 182) "singlemarketdata-marketid-182.json")

   (let ((response (cryptsy-public-api-get-market-data 182)))
     (should (= 5 (length (cryptsy-public-api-get-buy-orders 'DOGE response)))))
   
   )
  
  )

(ert-deftest cryptsy-public-api-test/can-get-buy-order-values ()
  (let ((contents (read-fixture "singlemarketdata-marketid-182.json")))
    (should (string= "0.00034259"
                     (assoc-default 'total (elt (cryptsy-public-api-get-buy-orders 'DOGE contents) 0))))))

(ert-deftest cryptsy-public-api-test/can-get-sell-orders ()
  (let ((contents (read-fixture "singlemarketdata-marketid-182.json")))
    (should (= 4 (length (cryptsy-public-api-get-sell-orders 'DOGE contents))))))


(ert-deftest cryptsy-public-api-test/can-get-sell-order-values ()
  (let ((contents (read-fixture "singlemarketdata-marketid-182.json")))
    (should (string= "0.00038221"
                     (assoc-default 'total (elt (cryptsy-public-api-get-sell-orders 'DOGE contents) 0))))))
