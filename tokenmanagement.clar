;; Token Management Smart Contract with Enhanced Features
;; Implements fungible token standard SIP-010

(impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

;; Define token constants
(define-constant contract-owner tx-sender)
(define-constant token-name "MyToken")
(define-constant token-symbol "MTK")
(define-constant token-decimals u6)
(define-data-var token-uri (optional (string-ascii 256)) (some "https://example.com/token-metadata"))

;; Define errors
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-insufficient-balance (err u102))
(define-constant err-invalid-recipient (err u103))
(define-constant err-paused (err u104))
(define-constant err-blacklisted (err u105))

;; Define token data variables
(define-data-var token-supply uint u0)
(define-data-var paused bool false)

;; Define data maps
(define-map balances
    principal
    uint)

(define-map allowances
    {spender: principal, owner: principal}
    uint)

(define-map blacklisted-addresses
    principal
    bool)

;; Read-only functions
(define-read-only (get-name)
    (ok token-name))

(define-read-only (get-symbol)
    (ok token-symbol))

(define-read-only (get-decimals)
    (ok token-decimals))

(define-read-only (get-balance (owner principal))
    (ok (default-to u0 (map-get? balances owner))))

(define-read-only (get-total-supply)
    (ok (var-get token-supply)))

(define-read-only (get-token-uri)
    (ok (var-get token-uri)))

(define-read-only (get-allowance (owner principal) (spender principal))
    (ok (default-to u0 (map-get? allowances {spender: spender, owner: owner}))))

(define-read-only (is-paused)
    (ok (var-get paused)))

(define-read-only (is-blacklisted (address principal))
    (ok (default-to false (map-get? blacklisted-addresses address))))

;; Public functions
(define-public (transfer (amount uint) (recipient principal))
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (asserts! (not (default-to false (map-get? blacklisted-addresses tx-sender))) err-blacklisted)
        (asserts! (not (default-to false (map-get? blacklisted-addresses recipient))) err-blacklisted)

        (let ((sender-balance (default-to u0 (map-get? balances tx-sender))))
            (asserts! (>= sender-balance amount) err-insufficient-balance)
            (asserts! (is-some (principal-destruct? recipient)) err-invalid-recipient)
            
            (map-set balances tx-sender (- sender-balance amount))
            (map-set balances recipient 
                (+ (default-to u0 (map-get? balances recipient)) amount))
            
            (print {type: "transfer", 
                    sender: tx-sender,
                    recipient: recipient,
                    amount: amount})
            (ok true))))

;; Additional admin functions

;; Pause or unpause token transfers
(define-public (set-pause (pause bool))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (var-set paused pause)
        (print {type: "set-pause", paused: pause})
        (ok true)))

;; Add or remove from blacklist
(define-public (set-blacklist (address principal) (blacklist bool))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (map-set blacklisted-addresses address blacklist)
        (print {type: "set-blacklist", address: address, blacklisted: blacklist})
        (ok true)))

;; Update token metadata URI
(define-public (update-token-uri (uri (optional (string-ascii 256))))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (var-set token-uri uri)
        (print {type: "update-token-uri", uri: uri})
        (ok true)))

;; Token airdrop
(define-public (airdrop (recipients (list 200 principal)) (amounts (list 200 uint)))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (is-eq (len recipients) (len amounts)) err-invalid-recipient)
        (map
            (lambda (recipient amount)
                (asserts! (is-some (principal-destruct? recipient)) err-invalid-recipient)
                (map-set balances recipient (+ (default-to u0 (map-get? balances recipient)) amount))
                (var-set token-supply (+ (var-get token-supply) amount))
                (print {type: "airdrop", recipient: recipient, amount: amount}))
            recipients amounts)
        (ok true)))

;; Transfer contract ownership
(define-public (transfer-ownership (new-owner principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (define-constant contract-owner new-owner)
        (print {type: "transfer-ownership", new-owner: new-owner})
        (ok true)))
