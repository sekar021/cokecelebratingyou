ALTER TABLE RPT_GOAL_MANAGER_OVERRIDE MODIFY PROMOTION_NAME VARCHAR2(1000 CHAR)
/
ALTER TABLE RPT_GOAL_MANAGER_OVERRIDE MODIFY OVERRIDE_AMOUNT NUMBER(12,2)
/
ALTER TABLE RPT_GOAL_PARTNER MODIFY PAX_DEPARTMENT VARCHAR2(100)
/
ALTER TABLE RPT_GOAL_PARTNER MODIFY PROMOTION_NAME VARCHAR2(1000)
/
ALTER TABLE RPT_GOAL_PARTNER MODIFY GOAL_LEVEL_NAME VARCHAR2(255)
/
ALTER TABLE RPT_GOAL_PARTNER MODIFY BASE_QUANTITY NUMBER(18,4)
/