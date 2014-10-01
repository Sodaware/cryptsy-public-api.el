(ert-deftest cryptsy-public-api-test/can-create-endpoint ()
  (should (string=
           "http://pubapi.cryptsy.com/api.php?method=singlemarketdata&marketid=182"
           (cryptsy-public-api-create-endpoint (list :method "singlemarketdata"
                                                     :marketid 182)))))

(ert-deftest cryptsy-public-api-test/can-build-query ()
  (should (string=
           "method=singlemarketdata&marketid=182"
           (cryptsy-public-api-build-query (list :method "singlemarketdata"
                                                 :marketid 182)))))

(ert-deftest cryptsy-public-api-test/can-get-named-value ()
  (let ((contents (read-fixture "singlemarketdata-marketid-182.json")))
    (should (string= "DOGE"
                     (cryptsy-public-api-get-info-value 'DOGE 'primarycode contents)))))

