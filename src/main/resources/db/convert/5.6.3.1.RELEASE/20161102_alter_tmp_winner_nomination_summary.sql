DROP TABLE TMP_WINNER_NOMINATION_SUMMARY
/

CREATE GLOBAL TEMPORARY TABLE TMP_WINNER_NOMINATION_SUMMARY
(
   activity_id              NUMBER(18),
   claim_id                 NUMBER(18),
   claim_group_id			NUMBER(18),
   nominee_first_name       VARCHAR2(255 CHAR),
   nominee_last_name        VARCHAR2(255 CHAR),
   nominee_user_id          NUMBER(18),
   time_period_id           NUMBER(18),
   time_period_name         VARCHAR2(4000 CHAR),
   nominee_hierarchy_id     NUMBER(18),
   nominee_org_name         VARCHAR2(4000 CHAR),
   nominee_job_position     VARCHAR2(4000 CHAR),
   nominee_country_code     VARCHAR2(5 CHAR),
   nominee_country_name     VARCHAR2(255 CHAR),
   nominee_avatar_url       VARCHAR2(100 CHAR),
   nominator_first_name     VARCHAR2(255 CHAR),
   nominator_last_name      VARCHAR2(255 CHAR),
   nominator_user_id        NUMBER(18),
   nominator_hierarchy_id   NUMBER(18),
   nominator_org_name       VARCHAR2(4000 CHAR),
   nominator_job_position   VARCHAR2(4000 CHAR),
   nominator_country_code   VARCHAR2(5 CHAR),  
   nominator_country_name   VARCHAR2(4000 CHAR),
   submitter_comments       VARCHAR2(4000 CHAR),
   promotion_name           VARCHAR2(4000 CHAR),
   team_id                  NUMBER(18),
   team_name                VARCHAR2(100 CHAR),
   level_id                 NUMBER(18),
   level_name               VARCHAR2(4000 CHAR),
   promotion_id             NUMBER(18),
   date_approved            DATE,
   nominator_department     VARCHAR2(100),
   nominee_department       VARCHAR2(100)
)
ON COMMIT PRESERVE  ROWS
/
