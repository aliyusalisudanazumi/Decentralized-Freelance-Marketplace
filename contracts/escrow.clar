;; Escrow Contract

(define-map escrows
  { escrow-id: uint }
  {
    client: principal,
    freelancer: principal,
    amount: uint,
    status: (string-ascii 20)
  }
)

(define-data-var escrow-nonce uint u0)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_NOT_FOUND (err u404))
(define-constant ERR_INSUFFICIENT_FUNDS (err u402))

(define-public (create-escrow (freelancer principal) (amount uint))
  (let
    (
      (escrow-id (+ (var-get escrow-nonce) u1))
    )
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (map-set escrows
      { escrow-id: escrow-id }
      {
        client: tx-sender,
        freelancer: freelancer,
        amount: amount,
        status: "funded"
      }
    )
    (var-set escrow-nonce escrow-id)
    (ok escrow-id)
  )
)

(define-public (release-funds (escrow-id uint))
  (let
    (
      (escrow (unwrap! (map-get? escrows { escrow-id: escrow-id }) ERR_NOT_FOUND))
    )
    (asserts! (is-eq (get client escrow) tx-sender) ERR_UNAUTHORIZED)
    (asserts! (is-eq (get status escrow) "funded") ERR_UNAUTHORIZED)
    (try! (as-contract (stx-transfer? (get amount escrow) tx-sender (get freelancer escrow))))
    (map-set escrows
      { escrow-id: escrow-id }
      (merge escrow { status: "released" })
    )
    (ok true)
  )
)

(define-public (refund (escrow-id uint))
  (let
    (
      (escrow (unwrap! (map-get? escrows { escrow-id: escrow-id }) ERR_NOT_FOUND))
    )
    (asserts! (is-eq (get client escrow) tx-sender) ERR_UNAUTHORIZED)
    (asserts! (is-eq (get status escrow) "funded") ERR_UNAUTHORIZED)
    (try! (as-contract (stx-transfer? (get amount escrow) tx-sender (get client escrow))))
    (map-set escrows
      { escrow-id: escrow-id }
      (merge escrow { status: "refunded" })
    )
    (ok true)
  )
)

(define-read-only (get-escrow (escrow-id uint))
  (map-get? escrows { escrow-id: escrow-id })
)

