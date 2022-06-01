ALTER TABLE NOMINATION_CLAIM MODIFY TEAM_NAME VARCHAR2(50)
/
ALTER TABLE NOMINATION_CLAIM MODIFY COPY_SENDER NUMBER(1,0)
/
ALTER TABLE NOMINATION_CLAIM MODIFY HIDE_PUBLIC_RECOGNITION NUMBER(1,0) DEFAULT 0
/
ALTER TABLE NOMINATION_CLAIM
ADD CERTIFICATE_ID NUMBER(12)
/
ALTER TABLE NOMINATION_CLAIM
ADD MORE_INFO_COMMENTS VARCHAR2(4000)
/
ALTER TABLE NOMINATION_CLAIM
ADD STATUS VARCHAR2(30 CHAR)
/
ALTER TABLE NOMINATION_CLAIM
ADD NOMINATION_TIME_PERIOD_ID NUMBER(18,0)
/
ALTER TABLE NOMINATION_CLAIM
ADD STEP_NUMBER NUMBER(2)
/
ALTER TABLE NOMINATION_CLAIM
ADD IS_REVERSE NUMBER(1,0) DEFAULT 0
/
ALTER TABLE NOMINATION_CLAIM
ADD WHY_ATTACHMENT_URL VARCHAR2(400 CHAR)
/
ALTER TABLE NOMINATION_CLAIM
ADD WHY_ATTACHMENT_NAME VARCHAR2(400 CHAR)
/
ALTER TABLE NOMINATION_CLAIM
ADD CARD_VIDEO_URL VARCHAR2(400 CHAR)
/
ALTER TABLE NOMINATION_CLAIM
ADD CARD_VIDEO_IMAGE_URL VARCHAR2(400 CHAR)
/
ALTER TABLE nomination_claim ADD CONSTRAINT promo_nom_time_period_fk
FOREIGN KEY (NOMINATION_TIME_PERIOD_ID) REFERENCES PROMO_NOMINATION_TIME_PERIOD (NOMINATION_TIME_PERIOD_ID)
/
ALTER TABLE nomination_claim
ADD DRAWING_DATA_URL VARCHAR2(400 CHAR)
/
ALTER TABLE nomination_claim
ADD card_type VARCHAR2(20)
/