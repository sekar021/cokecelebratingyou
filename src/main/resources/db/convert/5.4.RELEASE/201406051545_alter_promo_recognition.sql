ALTER TABLE promo_recognition ADD
(
	IS_MOB_APP_ENABLED					NUMBER(1) DEFAULT 0,
	IS_PURL_STANDARD_MESSAGE			NUMBER(1) DEFAULT 0,
	PURL_STANDARD_MESSAGE				VARCHAR2(1024),
	DEFAULT_CONTRIBUTOR_AVATAR			VARCHAR2(512),
	DEFAULT_CONTRIBUTOR_NAME			VARCHAR2(50),
	CONTENT_RESOURCE                    VARCHAR2(100),
	INCLUDE_CELEBRATIONS				NUMBER(1) DEFAULT 0,
	CELEBRATION_DISPLAY_PERIOD			NUMBER(4),
	ALLOW_OWNER_MESSAGE					NUMBER(1) DEFAULT 1,
	DEFAULT_MESSAGE						VARCHAR(1500),
	YEAR_TILE_ENABLED					NUMBER(1) DEFAULT 0,
	TIMELINE_TILE_ENABLED				NUMBER(1) DEFAULT 0,
	VIDEO_TILE_ENABLED					NUMBER(1) DEFAULT 0,
	VIDEO_PATH							VARCHAR(30),
	SHARE_TO_MEADIA						NUMBER(1) DEFAULT 1,
 	FILLER_IMG_1_AWARD_NUM_ENABLED      NUMBER(1) DEFAULT 0 NOT NULL,
 	FILLER_IMG_2_AWARD_NUM_ENABLED      NUMBER(1) DEFAULT 0 NOT NULL,
 	FILLER_IMG_3_AWARD_NUM_ENABLED      NUMBER(1) DEFAULT 0 NOT NULL,
 	FILLER_IMG_4_AWARD_NUM_ENABLED      NUMBER(1) DEFAULT 0 NOT NULL,
 	FILLER_IMG_5_AWARD_NUM_ENABLED      NUMBER(1) DEFAULT 0 NOT NULL,
	CELEBRATION_FILLER_IMAGE_1			VARCHAR(30),
	CELEBRATION_FILLER_IMAGE_2			VARCHAR(30),
	CELEBRATION_FILLER_IMAGE_3			VARCHAR(30),
	CELEBRATION_FILLER_IMAGE_4			VARCHAR(30),
	CELEBRATION_FILLER_IMAGE_5			VARCHAR(30),
	SERVICE_ANNIVERSARY                 NUMBER(1) DEFAULT 1,
	ANNIVERSARY_IN_YEARS				NUMBER(2),
	CELEBRATION_GENERIC_ECARD			VARCHAR(30),
	DISPLAY_PURL_IN_PURL_TILE           NUMBER(1) DEFAULT 0
)
/
COMMENT ON COLUMN PROMO_RECOGNITION.IS_MOB_APP_ENABLED  IS 'whether the promotion has MobileAPP enabled'
/
COMMENT ON COLUMN PROMO_RECOGNITION.FILLER_IMG_1_AWARD_NUM_ENABLED  IS 'whether the filler image 1 will use award number'
/
COMMENT ON COLUMN PROMO_RECOGNITION.FILLER_IMG_2_AWARD_NUM_ENABLED  IS 'whether the filler image 2 will use award number'
/
COMMENT ON COLUMN PROMO_RECOGNITION.FILLER_IMG_3_AWARD_NUM_ENABLED  IS 'whether the filler image 3 will use award number'
/
COMMENT ON COLUMN PROMO_RECOGNITION.FILLER_IMG_4_AWARD_NUM_ENABLED  IS 'whether the filler image 4 will use award number'
/
COMMENT ON COLUMN PROMO_RECOGNITION.FILLER_IMG_5_AWARD_NUM_ENABLED  IS 'whether the filler image 5 will use award number'
/