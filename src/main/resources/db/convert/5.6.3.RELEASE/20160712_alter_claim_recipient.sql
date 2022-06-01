ALTER TABLE CLAIM_RECIPIENT
ADD CASH_AWARD_QTY NUMBER(18,4)
/
ALTER TABLE CLAIM_RECIPIENT
ADD WINNER_MODAL_VIEWED NUMBER(1) DEFAULT 0
/
COMMENT ON COLUMN claim_recipient.WINNER_MODAL_VIEWED IS 'Indicates if the Nomination Winner viewed the Modal window after logging in'
/