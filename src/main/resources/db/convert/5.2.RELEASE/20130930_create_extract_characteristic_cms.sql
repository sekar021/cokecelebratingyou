CREATE GLOBAL TEMPORARY TABLE CHACRACTERISTICS_CMS
(
  CHARACTERISTIC_ID  NUMBER,
  CMS_NAME           VARCHAR2(100 CHAR),
  CMS_CODE           VARCHAR2(100 CHAR)
)
ON COMMIT PRESERVE ROWS
NOCACHE
/