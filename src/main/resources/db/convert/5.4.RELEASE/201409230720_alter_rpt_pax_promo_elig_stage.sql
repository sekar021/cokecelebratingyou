ALTER TABLE RPT_PAX_PROMO_ELIG_STAGE MODIFY ( 
		AUDIENCE_ID       NUMBER(18)
    )
/
ALTER TABLE rpt_cp_selection_detail
ADD TRANS_DATE DATE
/
ALTER TABLE RPT_CHARACTERISTIC
MODIFY CHARACTERISTIC_CHARVALUE1  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE2  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE3  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE4  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE5  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE6  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE7  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE8  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE9  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE10  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE11  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE12  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE13  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE14  VARCHAR2(255 CHAR)
MODIFY CHARACTERISTIC_CHARVALUE15  VARCHAR2(255 CHAR)
/