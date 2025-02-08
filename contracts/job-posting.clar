;; Job Posting Contract

(define-map jobs
  { job-id: uint }
  {
    client: principal,
    title: (string-ascii 64),
    description: (string-utf8 500),
    budget: uint,
    deadline: uint,
    status: (string-ascii 20)
  }
)

(define-map applications
  { job-id: uint, applicant: principal }
  { proposal: (string-utf8 500) }
)

(define-data-var job-nonce uint u0)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_NOT_FOUND (err u404))
(define-constant ERR_ALREADY_APPLIED (err u409))

(define-public (post-job (title (string-ascii 64)) (description (string-utf8 500)) (budget uint) (deadline uint))
  (let
    (
      (job-id (+ (var-get job-nonce) u1))
    )
    (map-set jobs
      { job-id: job-id }
      {
        client: tx-sender,
        title: title,
        description: description,
        budget: budget,
        deadline: deadline,
        status: "open"
      }
    )
    (var-set job-nonce job-id)
    (ok job-id)
  )
)

(define-public (apply-for-job (job-id uint) (proposal (string-utf8 500)))
  (let
    (
      (job (unwrap! (map-get? jobs { job-id: job-id }) ERR_NOT_FOUND))
    )
    (asserts! (is-eq (get status job) "open") ERR_UNAUTHORIZED)
    (asserts! (is-none (map-get? applications { job-id: job-id, applicant: tx-sender })) ERR_ALREADY_APPLIED)
    (map-set applications
      { job-id: job-id, applicant: tx-sender }
      { proposal: proposal }
    )
    (ok true)
  )
)

(define-public (close-job (job-id uint))
  (let
    (
      (job (unwrap! (map-get? jobs { job-id: job-id }) ERR_NOT_FOUND))
    )
    (asserts! (is-eq (get client job) tx-sender) ERR_UNAUTHORIZED)
    (map-set jobs
      { job-id: job-id }
      (merge job { status: "closed" })
    )
    (ok true)
  )
)

(define-read-only (get-job (job-id uint))
  (map-get? jobs { job-id: job-id })
)

(define-read-only (get-application (job-id uint) (applicant principal))
  (map-get? applications { job-id: job-id, applicant: applicant })
)

