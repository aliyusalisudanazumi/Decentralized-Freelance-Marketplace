;; Reputation System Contract

(define-map user-ratings
  { user: principal }
  {
    total-score: uint,
    review-count: uint
  }
)

(define-map reviews
  { reviewer: principal, reviewee: principal }
  {
    rating: uint,
    comment: (string-utf8 500)
  }
)

(define-constant MIN_RATING u1)
(define-constant MAX_RATING u5)
(define-constant ERR_INVALID_RATING (err u400))
(define-constant ERR_SELF_REVIEW (err u401))
(define-constant ERR_ALREADY_REVIEWED (err u409))

(define-public (submit-review (reviewee principal) (rating uint) (comment (string-utf8 500)))
  (let
    (
      (reviewer tx-sender)
    )
    (asserts! (not (is-eq reviewer reviewee)) ERR_SELF_REVIEW)
    (asserts! (and (>= rating MIN_RATING) (<= rating MAX_RATING)) ERR_INVALID_RATING)
    (asserts! (is-none (map-get? reviews { reviewer: reviewer, reviewee: reviewee })) ERR_ALREADY_REVIEWED)
    (map-set reviews
      { reviewer: reviewer, reviewee: reviewee }
      { rating: rating, comment: comment }
    )
    (let
      (
        (current-rating (default-to { total-score: u0, review-count: u0 } (map-get? user-ratings { user: reviewee })))
      )
      (map-set user-ratings
        { user: reviewee }
        {
          total-score: (+ (get total-score current-rating) rating),
          review-count: (+ (get review-count current-rating) u1)
        }
      )
    )
    (ok true)
  )
)

(define-read-only (get-user-rating (user principal))
  (let
    (
      (rating (default-to { total-score: u0, review-count: u0 } (map-get? user-ratings { user: user })))
    )
    (if (is-eq (get review-count rating) u0)
      (ok u0)
      (ok (/ (get total-score rating) (get review-count rating)))
    )
  )
)

(define-read-only (get-review (reviewer principal) (reviewee principal))
  (map-get? reviews { reviewer: reviewer, reviewee: reviewee })
)

