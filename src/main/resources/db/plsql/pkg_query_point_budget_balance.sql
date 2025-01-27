
create or replace PACKAGE pkg_query_point_budget_balance
IS
/******************************************************************************
  NAME:       pkg_query_point_budget_balance
  Date               Author           Description
  ----------       -------------      ------------------------------------------------
 12/15/2016         nagarajs          Initial Creation - G5.6.3.3 Budget Redesign
 *****************************************************************************/
PROCEDURE prc_getBalanceTabRes(
    p_in_languageCode       IN VARCHAR,
    p_in_rowNumEnd          IN NUMBER,
    p_in_rowNumStart        IN NUMBER,
    p_in_parentNodeId       IN VARCHAR,
    p_in_promotionId        IN VARCHAR,
    p_in_budgetStatus       IN VARCHAR,
    p_in_budgetDistribution IN VARCHAR,
    p_in_countryRatio       IN NUMBER,   
    p_in_sortedOn           IN VARCHAR,
    p_in_sortedBy           IN VARCHAR,
    p_out_return_code       OUT NUMBER,
    p_out_data              OUT SYS_REFCURSOR,
    p_out_totals_data       OUT SYS_REFCURSOR);
PROCEDURE prc_getBalanceByPromoTabRes(
    p_in_languageCode       IN VARCHAR,
    p_in_rowNumEnd          IN NUMBER,
    p_in_rowNumStart        IN NUMBER,
    p_in_parentNodeId       IN VARCHAR,
    p_in_promotionId        IN VARCHAR,
    p_in_budgetStatus       IN VARCHAR,
    p_in_budgetDistribution IN VARCHAR,
    p_in_countryRatio       IN NUMBER,   
    p_in_sortedOn           IN VARCHAR,
    p_in_sortedBy           IN VARCHAR,
    p_in_bud_seg_id         IN NUMBER,
    p_out_return_code       OUT NUMBER,
    p_out_data              OUT SYS_REFCURSOR,
    p_out_totals_data       OUT SYS_REFCURSOR);
PROCEDURE prc_getUseInPointsChart(
    p_in_languageCode       IN VARCHAR,
    p_in_rowNumEnd          IN NUMBER,
    p_in_rowNumStart        IN NUMBER,
    p_in_parentNodeId       IN VARCHAR,
    p_in_promotionId        IN VARCHAR,
    p_in_budgetStatus       IN VARCHAR,
    p_in_budgetDistribution IN VARCHAR,
    p_in_countryRatio       IN NUMBER,   
    p_in_sortedOn           IN VARCHAR,
    p_in_sortedBy           IN VARCHAR,
    p_out_return_code       OUT NUMBER,
    p_out_data              OUT SYS_REFCURSOR);
PROCEDURE prc_getUseByPercentageChart(
    p_in_languageCode       IN VARCHAR,
    p_in_rowNumEnd          IN NUMBER,
    p_in_rowNumStart        IN NUMBER,
    p_in_parentNodeId       IN VARCHAR,
    p_in_promotionId        IN VARCHAR,
    p_in_budgetStatus       IN VARCHAR,
    p_in_budgetDistribution IN VARCHAR,
    p_in_countryRatio       IN NUMBER,   
    p_in_sortedOn           IN VARCHAR,
    p_in_sortedBy           IN VARCHAR,
    p_out_return_code       OUT NUMBER,
    p_out_data              OUT SYS_REFCURSOR);
END pkg_query_point_budget_balance;
/

create or replace PACKAGE BODY pkg_query_point_budget_balance
IS
-- package constants

gc_null_id                       CONSTANT NUMBER(18) := pkg_const.gc_null_id;
gc_search_all_values             CONSTANT VARCHAR2(30) := pkg_const.gc_search_all_values;
gc_cms_key_fld_promotion_name    CONSTANT VARCHAR2(30) := pkg_const.gc_cms_key_fld_promotion_name;
gc_cms_key_fld_bud_master_name   CONSTANT VARCHAR2(30) := pkg_const.gc_cms_key_fld_bud_master_name;

gc_ref_text_budget_status        CONSTANT gtt_id_list.ref_text_1%TYPE := 'budget_status';
gc_ref_text_parent_node_id       CONSTANT gtt_id_list.ref_text_1%TYPE := 'parent_node_id';
gc_ref_text_promotion_id         CONSTANT gtt_id_list.ref_text_1%TYPE := 'promotion_id';

PROCEDURE prc_getBalanceTabRes(
    p_in_languageCode       IN VARCHAR,
    p_in_rowNumEnd          IN NUMBER,
    p_in_rowNumStart        IN NUMBER,
    p_in_parentNodeId       IN VARCHAR,
    p_in_promotionId        IN VARCHAR,
    p_in_budgetStatus       IN VARCHAR,
    p_in_budgetDistribution IN VARCHAR,
    p_in_countryRatio       IN NUMBER,   
    p_in_sortedOn           IN VARCHAR,
    p_in_sortedBy           IN VARCHAR,
    p_out_return_code       OUT NUMBER,
    p_out_data              OUT SYS_REFCURSOR,
    p_out_totals_data       OUT SYS_REFCURSOR)
IS
/******************************************************************************
  NAME: prc_getBalanceTabRes
  Date          Author           Description
  ----------    ---------------  ------------------------------------------------
  12/15/2016    nagarajs         Initial Creation - G5.6.3.3 Budget Redesign
  08/10/2017    Gorantla         JIRA# G6-2800 - To pass list of promotion ids for shared distribution type.
  05/02/2018    Gorantla         Bug#76460 - budget amount is wrong for shared buget when more than one user/node use same budget amount
  04/03/2017    Sherif Basha     Bug 72096 - Point Budget Balance Report - Budget Period Field drilling down ,records are not displaying correctly as per date range for Pax and node budget
                                        (Added budget_segment_id to resultset required for Java to input for detail level) --12/04/2018 copied
  04/15/2019    Suresh J         Bug 79030 - Mismatch in displaying the Awarded amount between Summary and detail        
  06/24/2019    Loganathan S     Bug 79074 - Point budget balance report-Shared budget-The budget balance report original 
  										     balance value is not matching when do a drill down for the budget owners                                  
  ******************************************************************************/
  c_process_name        CONSTANT execution_log.process_name%TYPE := 'prc_getBalanceTabRes' ;
  v_stage               execution_log.text_line%TYPE;
  v_parms               execution_log.text_line%TYPE;
  L_sort_on             VARCHAR2(30);
  L_sort_by             VARCHAR2(30);
  v_budget_media_value  NUMBER(12,4);  
  v_fetch_count         INTEGER;
  v_data_sort           VARCHAR2(50);
  v_localeDatePattern   VARCHAR2(50) := 'MM/DD/YYYY';

   CURSOR cur_query_ref IS
   SELECT CAST(NULL AS VARCHAR2(2000)) AS promo_id,     -- 08/10/2017 JIRA# G6-2800
          CAST(NULL AS VARCHAR2(2000)) AS promo_name,
          CAST(NULL AS VARCHAR2(2000)) AS budget_master_name,
          CAST(NULL AS VARCHAR2(100)) AS budget_period,
          CAST(NULL AS NUMBER) AS original_budget,
          CAST(NULL AS NUMBER) AS budget_adjustments,
          CAST(NULL AS NUMBER) AS awarded,
          CAST(NULL AS NUMBER) AS available_balance,
          CAST(NULL AS NUMBER) AS budget_segment_id,   -- 04/03/2017   Bug 72096
          CAST(NULL AS NUMBER) AS total_records,
          CAST(NULL AS NUMBER) AS rec_seq
     FROM dual;

   rec_query      cur_query_ref%ROWTYPE;    


BEGIN
   v_stage := 'initialize variables';
   v_parms := '~Parms'
      ||  ': p_in_languageCode >' || p_in_languageCode
      || '<, p_in_rowNumEnd >' || p_in_rowNumEnd
      || '<, p_in_rowNumStart >' || p_in_rowNumStart
      || '<, p_in_parentNodeId >' || p_in_parentNodeId
      || '<, p_in_promotionId >' || p_in_promotionId
      || '<, p_in_budgetStatus >' || p_in_budgetStatus
      || '<, p_in_budgetDistribution >' || p_in_budgetDistribution
      || '<, p_in_countryRatio >' || p_in_countryRatio              
      || '<, p_in_sortedOn >' || p_in_sortedOn
      || '<, p_in_sortedBy >' || p_in_sortedBy
      || '<';

   -- set data sort
   IF (LOWER(p_in_sortedBy) = 'desc') THEN
      v_data_sort := LOWER(p_in_sortedBy || '/' || p_in_sortedOn);
   ELSE
      v_data_sort := LOWER(p_in_sortedOn);
   END IF;
 
   BEGIN                                                                    
     SELECT (budget_media_value / p_in_countryRatio)
      INTO v_budget_media_value  
      FROM country c      
     WHERE c.cm_asset_code ='country_data.country.usa';                       
   END;                                                                     
  
   -- stage input lists
   v_stage := 'stage input lists';
   DELETE gtt_id_list;
   pkg_report_common.p_stage_search_criteria(NVL(p_in_parentNodeId, pkg_report_common.f_get_root_node), gc_ref_text_parent_node_id, 1); 
   pkg_report_common.p_stage_search_criteria(NVL(p_in_budgetStatus, gc_search_all_values), gc_ref_text_budget_status);
   pkg_report_common.p_stage_search_criteria(NVL(p_in_promotionId, gc_search_all_values), gc_ref_text_promotion_id, 1);
   
   v_stage := 'OPEN p_out_data';
   OPEN p_out_data FOR 
   WITH w_budget AS
    ( -- build initial data set
      SELECT bp.promotion_id AS promo_id
           , btd.budget_id --05/02/2018
           , bp.budget_master_id
           , mv_pn.cms_value   AS promo_name
           , mv_bm.cms_value   AS budget_master_name 
           , bp.distribution_type
           , TO_CHAR (bud.start_date, v_localeDatePattern)
             || ' To '
             || NVL( TO_CHAR(bud.end_date, v_localeDatePattern), ' No End Date ') AS budget_period
           , btd.budget_trans_type
           , btd.trans_amount
           , rnk
           , bb.budget_segment_id       -- 04/03/2017   Bug 72096
           , RPT_BUDGET_TRANS_DETAIL_ID --06/24/2019 Bug#79074
     FROM budget_segment bb
          , rpt_budget_promotion bp
          ,(SELECT RANK() OVER(PARTITION BY budget_id ORDER BY budget_history_id ) rnk, r.*
              FROM rpt_budget_trans_detail r) btd
          , rpt_budget_usage_detail bud
          , promotion p
          , gtt_id_list gil_b  -- budget status
          , gtt_id_list gil_p  -- promotion
          , mv_cms_asset_value mv_pn
          , mv_cms_asset_value mv_bm
    WHERE bb.budget_segment_id = btd.budget_segment_id
      AND btd.budget_id = bp.budget_id
      AND bp.distribution_type = NVL(p_in_budgetDistribution, bp.distribution_type)
      AND btd.budget_id = bud.budget_id
      AND ( bud.node_id IN
                ( -- get child nodes based on input parent node(s)
                  SELECT child_node_id
                    FROM rpt_hierarchy_rollup hr,
                         gtt_id_list gil_hr -- hierarchy rollup
                   WHERE gil_hr.ref_text_1 = gc_ref_text_parent_node_id
                     AND gil_hr.id = hr.node_id 
                )
             OR ( bud.budget_owner_type = 'promotion'
                AND bud.node_id IS NULL)
           )
      AND gil_p.ref_text_1 = gc_ref_text_promotion_id
      AND (  gil_p.ref_text_2 = gc_search_all_values
            OR gil_p.id = bp.promotion_id )
      AND gil_b.ref_text_1 = gc_ref_text_budget_status
      AND (  gil_b.ref_text_2 = gc_search_all_values
            OR gil_b.ref_text_2 = btd.budget_status )
      AND bp.promotion_id = p.promotion_id
      AND ((p_in_promotionId IS NULL AND p.promotion_status IN('live','expired')) 
      OR (p_in_promotionId IS NOT NULL AND p.promotion_status = 'live'))
      AND p.promo_name_asset_code        = mv_pn.asset_code (+)
      AND gc_cms_key_fld_promotion_name  = mv_pn.key (+)
      AND p_in_languageCode              = mv_pn.locale (+) 
      AND bud.budget_name_cm_asset_code  = mv_bm.asset_code (+)
      AND gc_cms_key_fld_bud_master_name = mv_bm.key (+)
      AND p_in_languageCode              = mv_bm.locale (+) 
     )
   SELECT s.*
     FROM ( -- sequence the data
            SELECT rd.*,
                   COUNT(rd.promo_id) OVER() AS total_records,
                   -- calc record sort order
                   ROW_NUMBER() OVER (ORDER BY
                     -- sort totals record first
                     DECODE(rd.promo_id, NULL, 0, 99),
                     -- ascending sorts
                     DECODE(v_data_sort, 'promo_id',            rd.promo_id),
                     DECODE(v_data_sort, 'promo_name',          LOWER(rd.promo_name)),
                     DECODE(v_data_sort, 'budget_master_name',  LOWER(rd.budget_master_name)),
                     DECODE(v_data_sort, 'budget_period',       rd.budget_period),
                     DECODE(v_data_sort, 'original_budget',     rd.original_budget),
                     DECODE(v_data_sort, 'budget_adjustments',  rd.budget_adjustments),
                     DECODE(v_data_sort, 'awarded',             rd.awarded),
                     DECODE(v_data_sort, 'available_balance',   rd.available_balance),
                     -- descending sorts
                     DECODE(v_data_sort, 'desc/promo_id',               rd.promo_id) DESC,
                     DECODE(v_data_sort, 'desc/promo_name',             LOWER(rd.promo_name)) DESC,
                     DECODE(v_data_sort, 'desc/budget_master_name',     LOWER(rd.budget_master_name)) DESC,
                     DECODE(v_data_sort, 'desc/budget_period',          rd.budget_period) DESC,
                     DECODE(v_data_sort, 'desc/original_budget',        rd.original_budget) DESC,
                     DECODE(v_data_sort, 'desc/budget_adjustments',     rd.budget_adjustments) DESC,
                     DECODE(v_data_sort, 'desc/awarded',                rd.awarded) DESC,
                     DECODE(v_data_sort, 'desc/available_balance',      rd.available_balance) DESC,
                     -- default sort fields
                     LOWER(rd.promo_name),
                     rd.promo_id,
                     rd.budget_segment_id           -- 04/03/2017   Bug 72096
                   ) -1 AS rec_seq
              FROM ( SELECT ds.promo_id,
                            ds.promo_name,
                            ds.budget_master_name,
                            ds.budget_period,
                            ROUND(ds.original_budget * v_budget_media_value,0) AS original_budget,       
                            ROUND((budget_adjustments - ds.original_budget) * v_budget_media_value,0) AS budget_adjustments, 
                            ROUND(ds.awarded * v_budget_media_value,0) AS awarded,
                            ROUND(((ds.original_budget + (budget_adjustments - ds.original_budget) ) - ds.awarded) * v_budget_media_value,0) AS available_balance,
                            ds.budget_segment_id      -- 04/03/2017   Bug 72096      
                       FROM ( -- build initial data set
                              SELECT promo_id
                                   , promo_name
                                   , budget_master_name 
                                   , budget_period
                                   , SUM(original_budget) AS original_budget
                                   , SUM(awarded) AS awarded
                                   , SUM(budget_adjustments)  AS budget_adjustments
                                   , budget_segment_id          -- 04/03/2017   Bug 72096
                               FROM (SELECT to_char(promo_id) promo_id  --08/10/2017 JIRA# G6-2800
                                           , budget_master_id
                                           , promo_name
                                           , budget_master_name 
                                           , budget_period
                                           , (SUM(CASE WHEN budget_trans_type = 'deposit'  AND rnk = 1
                                                  THEN NVL(trans_amount, 0)
                                                  ELSE 0
                                                  END)) AS original_budget
                                           , SUM(CASE WHEN budget_trans_type = 'expenditure' 
                                                      THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END) AS awarded
                                           , SUM(CASE WHEN budget_trans_type IN ( 'deposit', 'transfer')
                                                      THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END) AS budget_adjustments
                                           , budget_segment_id          -- 04/03/2017   Bug 72096
                                      FROM w_budget
                                     WHERE distribution_type <> 'shared'
                                     GROUP BY promo_id
                                           , budget_master_id
                                           , promo_name
                                           , budget_master_name 
                                           , budget_period
                                           , budget_segment_id          -- 04/03/2017   Bug 72096
                                     UNION ALL
                                    SELECT wl.promo_id AS promo_id   -- 08/10/2017 JIRA# G6-2800
                                           , wb.budget_master_id
                                           , wl.promo_name
                                           , wb.budget_master_name 
                                           , wb.budget_period
                                           , (SUM(CASE WHEN budget_trans_type = 'deposit'  AND rnk = 1
                                                              THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END)) AS original_budget
                                           , SUM(CASE WHEN budget_trans_type = 'expenditure' 
                                                      THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END) AS awarded
                                           , SUM(CASE WHEN budget_trans_type IN ( 'deposit', 'transfer')
                                                      THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END) AS budget_adjustments
                                            , budget_segment_id         -- 04/03/2017   Bug 72096
                                      FROM (SELECT budget_master_id
                                                   , budget_master_name 
                                                   , budget_period
                                                   , budget_trans_type
                                                   , sum(trans_amount) as trans_amount --05/02/2018
                                                   , rnk
                                                   , budget_segment_id      -- 04/03/2017   Bug 72096
                                              FROM (select budget_id,budget_master_id  --05/02/2018 start   --04/15/2019  removed distinct
                                                   , budget_master_name 
                                                   , budget_period
                                                   , budget_trans_type
                                                   , trans_amount
                                                   , rnk   --05/02/2018 end
                                                   , budget_segment_id      -- 04/03/2017   Bug 72096
                                                   ,row_number() over(partition by budget_id,RPT_BUDGET_TRANS_DETAIL_ID order by promo_id) rn  --06/24/2019 Bug#79074
						     from w_budget   
                                             WHERE distribution_type = 'shared')
                                             WHERE rn = 1    --06/24/2019 Bug#79074
                                             GROUP BY budget_master_id
                                                   , budget_master_name 
                                                   , budget_period
                                                   , budget_trans_type
                                                   , trans_amount
                                                   , rnk
                                                   , budget_segment_id      -- 04/03/2017   Bug 72096
                                            ) wb,
                                           (SELECT budget_master_id,
                                                   LISTAGG(promo_id,',')  WITHIN GROUP (ORDER BY promo_id) AS promo_id --08/10/2017 JIRA# G6-2800
                                                    , LISTAGG(promo_name,',')  WITHIN GROUP (ORDER BY promo_name) AS promo_name
                                               FROM (SELECT budget_master_id, promo_name ,
                                                            promo_id --08/10/2017 JIRA# G6-2800
                                                       FROM w_budget
                                                      WHERE distribution_type = 'shared'
                                                      GROUP BY budget_master_id, promo_name,
                                                               promo_id --08/10/2017 JIRA# G6-2800
                                                    )
                                              GROUP BY budget_master_id
                                           ) wl
                                     WHERE wb.budget_master_id = wl.budget_master_id
                                     GROUP BY promo_id --08/10/2017 JIRA# G6-2800
                                           , wb.budget_master_id
                                           , wl.promo_name
                                           , wb.budget_master_name 
                                           , wb.budget_period
                                           , wb.budget_segment_id           -- 04/03/2017   Bug 72096
                                   )
                             GROUP BY GROUPING SETS
                                  ((), (promo_id
                                        , promo_name 
                                        , budget_master_name
                                        , budget_period
                                        , budget_segment_id))               -- 04/03/2017   Bug 72096
                            ) ds
                   ) rd -- full result set
          ) s -- sort number result set
     WHERE (  s.rec_seq = 0   -- totals record
          OR -- reduce sequenced data set to just the output page's records
             (   s.rec_seq > p_in_rowNumStart
             AND s.rec_seq < p_in_rowNumEnd )
          )
    ORDER BY s.rec_seq;

   -- query totals data
   v_stage := 'FETCH p_out_data totals record';
   FETCH p_out_data INTO rec_query;
   v_fetch_count := p_out_data%ROWCOUNT;

   v_stage := 'OPEN p_out_totals_data';
   OPEN p_out_totals_data FOR
   SELECT rec_query.original_budget     AS original_budget,
          rec_query.budget_adjustments  AS budget_adjustments,
          rec_query.awarded             AS awarded,
          rec_query.available_balance   AS available_balance
     FROM dual
    WHERE v_fetch_count = 1;

   v_stage := 'OPEN p_out_data NULL record';
   IF (v_fetch_count = 0) THEN
      -- reset data cursor with a null record
      OPEN p_out_data FOR
      SELECT CAST(NULL  AS VARCHAR2(2000)) AS promo_id,
              CAST(NULL AS VARCHAR2(2000)) AS promo_name,
              CAST(NULL AS VARCHAR2(2000)) AS budget_master_name,
              CAST(NULL AS VARCHAR2(100)) AS budget_period,
              CAST(NULL AS NUMBER) AS original_budget,
              CAST(NULL AS NUMBER) AS budget_adjustments,
              CAST(NULL AS NUMBER) AS awarded,
              CAST(NULL AS NUMBER) AS available_balance,
              CAST(NULL AS NUMBER) AS budget_segment_id,
              CAST(NULL AS NUMBER) AS total_records,
              CAST(NULL AS NUMBER) AS rec_seq
        FROM dual
       WHERE 0=1;
   END IF;

   p_out_return_code := '00';

EXCEPTION
   WHEN OTHERS THEN
      p_out_return_code := '99';
      prc_execution_log_entry (c_process_name, 1, 'ERROR', v_stage || SQLERRM || v_parms, NULL);
      OPEN p_out_data FOR SELECT NULL FROM DUAL;
      OPEN p_out_totals_data FOR SELECT NULL FROM DUAL;
END prc_getBalanceTabRes;

PROCEDURE prc_getBalanceByPromoTabRes(
    p_in_languageCode       IN VARCHAR,
    p_in_rowNumEnd          IN NUMBER,
    p_in_rowNumStart        IN NUMBER,
    p_in_parentNodeId       IN VARCHAR,
    p_in_promotionId        IN VARCHAR,
    p_in_budgetStatus       IN VARCHAR,
    p_in_budgetDistribution IN VARCHAR,
    p_in_countryRatio       IN NUMBER,   
    p_in_sortedOn           IN VARCHAR,
    p_in_sortedBy           IN VARCHAR,
    p_in_bud_seg_id         IN NUMBER,
    p_out_return_code       OUT NUMBER,
    p_out_data              OUT SYS_REFCURSOR,
    p_out_totals_data       OUT SYS_REFCURSOR)
IS
/******************************************************************************
  NAME: prc_getBalanceByPromoTabRes
  Date          Author           Description
  ----------    ---------------  ------------------------------------------------
  12/15/2016    nagarajs          Initial Creation - G5.6.3.3 Budget Redesign
  08/10/2017    Gorantla          JIRA# G6-2800  To pass list of promotion ids for shared distribution type
  04/03/2017    Sherif Basha      Bug 72096 - Point Budget Balance Report - Budget Period Field drilling down ,records are not displaying correctly as per date range for Pax and node budget
                                        (Added parameter p_in_bud_seg_id)
  ******************************************************************************/
  c_process_name        CONSTANT execution_log.process_name%TYPE := 'prc_getBalanceByPromoTabRes' ;
  v_stage               execution_log.text_line%TYPE;
  v_parms               execution_log.text_line%TYPE;
  L_sort_on             VARCHAR2(30);
  L_sort_by             VARCHAR2(30);
  v_budget_media_value  NUMBER(12,4);  
  v_fetch_count         INTEGER;
  v_data_sort           VARCHAR2(50);
  v_localeDatePattern   VARCHAR2(50) := 'MM/DD/YYYY';
  v_from_date          DATE;
  v_to_date            DATE;

   CURSOR cur_query_ref IS
   SELECT CAST(NULL AS VARCHAR2(4000)) AS budget_owner_name,
          CAST(NULL AS VARCHAR2(2000)) AS budget_master_name,
          CAST(NULL AS VARCHAR2(100)) AS budget_period,
          CAST(NULL AS NUMBER) AS original_budget,
          CAST(NULL AS NUMBER) AS budget_adjustments,
          CAST(NULL AS NUMBER) AS awarded,
          CAST(NULL AS NUMBER) AS available_balance,
          CAST(NULL AS NUMBER) AS total_records,
          CAST(NULL AS NUMBER) AS rec_seq
     FROM dual;

   rec_query      cur_query_ref%ROWTYPE;    


BEGIN
   v_stage := 'initialize variables';
   v_parms := '~Parms'
      ||  ': p_in_languageCode >' || p_in_languageCode
      || '<, p_in_rowNumEnd >' || p_in_rowNumEnd
      || '<, p_in_rowNumStart >' || p_in_rowNumStart
      || '<, p_in_parentNodeId >' || p_in_parentNodeId
      || '<, p_in_promotionId >' || p_in_promotionId
      || '<, p_in_budgetStatus >' || p_in_budgetStatus
      || '<, p_in_budgetDistribution >' || p_in_budgetDistribution
      || '<, p_in_countryRatio >' || p_in_countryRatio              
      || '<, p_in_sortedOn >' || p_in_sortedOn
      || '<, p_in_sortedBy >' || p_in_sortedBy
      || '<, p_in_bud_seg_id >' || p_in_bud_seg_id              
      || '<'; 
   
   -- set data sort
   IF (LOWER(p_in_sortedBy) = 'desc') THEN
      v_data_sort := LOWER(p_in_sortedBy || '/' || p_in_sortedOn);
   ELSE
      v_data_sort := LOWER(p_in_sortedOn);
   END IF;
 
   BEGIN                                                                    
     SELECT (budget_media_value / p_in_countryRatio)
      INTO v_budget_media_value  
      FROM country c      
     WHERE c.cm_asset_code ='country_data.country.usa';                       
   END;  
       
   -- stage input lists
   v_stage := 'stage input lists';
   DELETE gtt_id_list;
   pkg_report_common.p_stage_search_criteria(NVL(p_in_parentNodeId, pkg_report_common.f_get_root_node), gc_ref_text_parent_node_id, 1); 
   pkg_report_common.p_stage_search_criteria(NVL(p_in_budgetStatus, gc_search_all_values), gc_ref_text_budget_status);
   
   v_stage := 'OPEN p_out_data';
   OPEN p_out_data FOR 
   SELECT s.*
     FROM ( -- sequence the data
            SELECT rd.*,
                   COUNT(rd.budget_owner_name) OVER() AS total_records,
                   -- calc record sort order
                   ROW_NUMBER() OVER (ORDER BY
                     -- sort totals record first
                     DECODE(rd.budget_owner_name, NULL, 0, 99),
                     -- ascending sorts
                     DECODE(v_data_sort, 'budget_owner_name',   LOWER(rd.budget_owner_name)),
                     DECODE(v_data_sort, 'budget_master_name',  LOWER(rd.budget_master_name)),
                     DECODE(v_data_sort, 'budget_period',       rd.budget_period),
                     DECODE(v_data_sort, 'original_budget',     rd.original_budget),
                     DECODE(v_data_sort, 'budget_adjustments',  rd.budget_adjustments),
                     DECODE(v_data_sort, 'awarded',             rd.awarded),
                     DECODE(v_data_sort, 'available_balance',   rd.available_balance),
                     -- descending sorts
                     DECODE(v_data_sort, 'desc/budget_owner_name',      LOWER(rd.budget_owner_name)) DESC,
                     DECODE(v_data_sort, 'desc/budget_master_name',     LOWER(rd.budget_master_name)) DESC,
                     DECODE(v_data_sort, 'desc/budget_period',          rd.budget_period) DESC,
                     DECODE(v_data_sort, 'desc/original_budget',        rd.original_budget) DESC,
                     DECODE(v_data_sort, 'desc/budget_adjustments',     rd.budget_adjustments) DESC,
                     DECODE(v_data_sort, 'desc/awarded',                rd.awarded) DESC,
                     DECODE(v_data_sort, 'desc/available_balance',      rd.available_balance) DESC,
                     -- default sort fields
                     LOWER(rd.budget_owner_name)
                   ) -1 AS rec_seq
              FROM ( -- transform data into the full result set
                     SELECT ds.budget_owner_name,
                            ds.budget_master_name,
                            ds.budget_period,
                            ROUND(ds.original_budget * v_budget_media_value,0) AS original_budget,       
                            ROUND((budget_adjustments - ds.original_budget) * v_budget_media_value,0) AS budget_adjustments, 
                            ROUND(ds.awarded * v_budget_media_value,0) AS awarded,
                            ROUND(((ds.original_budget + (budget_adjustments - ds.original_budget)) - ds.awarded) * v_budget_media_value,0) AS available_balance
                       FROM ( -- build initial data set
                              SELECT bud.budget_id AS budget_id
                                   , bud.budget_owner_name AS budget_owner_name
                                   , mv_bm.cms_value   AS budget_master_name 
                                   , TO_CHAR (bud.start_date, v_localeDatePattern)
                                     || ' To '
                                     || NVL( TO_CHAR(bud.end_date, v_localeDatePattern), ' No End Date ') AS budget_period
                                   , (SUM(CASE WHEN btd.budget_trans_type = 'deposit'  AND rnk = 1
                                              THEN NVL(btd.trans_amount, 0)
                                         ELSE 0
                                        END)) AS original_budget
                                   , SUM(CASE WHEN btd.budget_trans_type = 'expenditure' 
                                              THEN NVL(btd.trans_amount, 0)
                                         ELSE 0
                                        END) AS awarded
                                   , SUM(CASE WHEN btd.budget_trans_type IN ( 'deposit', 'transfer')
                                              THEN NVL(btd.trans_amount, 0)
                                         ELSE 0
                                        END) AS budget_adjustments
                             FROM budget_segment bb
                                  , rpt_budget_promotion bp
                                  , (SELECT RANK() OVER(PARTITION BY budget_id ORDER BY budget_history_id ) rnk, r.*
                                       FROM rpt_budget_trans_detail r) btd
                                  , rpt_budget_usage_detail bud
                                  , promotion p
                                  , gtt_id_list gil_b  -- budget status
                                  , mv_cms_asset_value mv_bm
                            WHERE bb.budget_segment_id = btd.budget_segment_id
                              AND btd.budget_id = bp.budget_id
                              AND bp.distribution_type = NVL(p_in_budgetDistribution, bp.distribution_type) 
                              AND btd.budget_id = bud.budget_id
                              AND ( bud.node_id IN
                                        ( -- get child nodes based on input parent node(s)
                                          SELECT child_node_id
                                            FROM rpt_hierarchy_rollup hr,
                                                 gtt_id_list gil_hr -- hierarchy rollup
                                           WHERE gil_hr.ref_text_1 = gc_ref_text_parent_node_id
                                             AND gil_hr.id = hr.node_id 
                                        )
                                     OR ( bud.budget_owner_type = 'promotion'
                                        AND bud.node_id IS NULL)
                                   )
                              AND bb.budget_segment_id = p_in_bud_seg_id    -- 04/03/2017  Bug 72096
                              AND gil_b.ref_text_1 = gc_ref_text_budget_status
                              AND (  gil_b.ref_text_2 = gc_search_all_values
                                    OR gil_b.ref_text_2 = btd.budget_status )
                              AND bp.promotion_id = p.promotion_id
                              AND bp.promotion_id in (    SELECT REGEXP_SUBSTR (string_val,       -- 08/10/2017 JIRA# G6-2800
                                    '[^,]+',
                                    1,
                                    LEVEL)
                        global_assignee
                FROM (SELECT p_in_promotionId string_val
                        FROM dual )
                WHERE ROWNUM=1
          CONNECT BY LEVEL <=
                          LENGTH (string_val)
                        - LENGTH (REPLACE (string_val, ','))
                        + 1)  
                                ----- -- 08/10/2017 JIRA# G6-2800 End ---- 
                              AND bud.budget_name_cm_asset_code  = mv_bm.asset_code (+)
                              AND gc_cms_key_fld_bud_master_name = mv_bm.key (+)
                              AND p_in_languageCode              = mv_bm.locale (+) 
                            GROUP BY GROUPING SETS
                                  ((), (bud.budget_id
                                        , bud.budget_owner_name
                                        , mv_bm.cms_value
                                        , bud.start_date
                                        , bud.end_date)
                                  ) 
                            )ds -- initial data set
                   ) rd -- full result set
          ) s -- sort number result set
     WHERE (  s.rec_seq = 0   -- totals record
          OR -- reduce sequenced data set to just the output page's records
             (   s.rec_seq > p_in_rowNumStart
             AND s.rec_seq < p_in_rowNumEnd )
          )
    ORDER BY s.rec_seq;

   -- query totals data
   v_stage := 'FETCH p_out_data totals record';
   FETCH p_out_data INTO rec_query;
   v_fetch_count := p_out_data%ROWCOUNT;

   v_stage := 'OPEN p_out_totals_data';
   OPEN p_out_totals_data FOR
   SELECT rec_query.original_budget     AS original_budget,
          rec_query.budget_adjustments  AS budget_adjustments,
          rec_query.awarded             AS awarded,
          rec_query.available_balance   AS available_balance
     FROM dual
    WHERE v_fetch_count = 1;

   v_stage := 'OPEN p_out_data NULL record';
   IF (v_fetch_count = 0) THEN
      -- reset data cursor with a null record
      OPEN p_out_data FOR
       SELECT CAST(NULL AS VARCHAR2(4000)) AS budget_owner_name,
              CAST(NULL AS VARCHAR2(2000)) AS budget_master_name,
              CAST(NULL AS VARCHAR2(100)) AS budget_period,
              CAST(NULL AS NUMBER) AS original_budget,
              CAST(NULL AS NUMBER) AS budget_adjustments,
              CAST(NULL AS NUMBER) AS awarded,
              CAST(NULL AS NUMBER) AS available_balance,
              CAST(NULL AS NUMBER) AS total_records,
              CAST(NULL AS NUMBER) AS rec_seq
        FROM dual
       WHERE 0=1;
   END IF;

   p_out_return_code := '00';

EXCEPTION
   WHEN OTHERS THEN
      p_out_return_code := '99';
      prc_execution_log_entry (c_process_name, 1, 'ERROR', v_stage || SQLERRM || v_parms, NULL);
      OPEN p_out_data FOR SELECT NULL FROM DUAL;
      OPEN p_out_totals_data FOR SELECT NULL FROM DUAL;
END prc_getBalanceByPromoTabRes;

PROCEDURE prc_getUseInPointsChart(
    p_in_languageCode       IN VARCHAR,
    p_in_rowNumEnd          IN NUMBER,
    p_in_rowNumStart        IN NUMBER,
    p_in_parentNodeId       IN VARCHAR,
    p_in_promotionId        IN VARCHAR,
    p_in_budgetStatus       IN VARCHAR,
    p_in_budgetDistribution IN VARCHAR,
    p_in_countryRatio       IN NUMBER,   
    p_in_sortedOn           IN VARCHAR,
    p_in_sortedBy           IN VARCHAR,
    p_out_return_code       OUT NUMBER,
    p_out_data              OUT SYS_REFCURSOR)
IS
/******************************************************************************
  NAME: prc_getUseInPointsChart
  Date          Author           Description
  ----------    ---------------  ------------------------------------------------
  12/15/2016    nagarajs          Initial Creation - G5.6.3.3 Budget Redesign
  04/15/2019    Suresh J         Bug 79030 - Mismatch in displaying the Awarded amount between Summary and detail
  ******************************************************************************/
  c_process_name        CONSTANT execution_log.process_name%TYPE := 'prc_getUseInPointsChart' ;
  v_stage               execution_log.text_line%TYPE;
  v_parms               execution_log.text_line%TYPE;
  v_budget_media_value  NUMBER(12,4);
  v_localeDatePattern   VARCHAR2(50) := 'MM/DD/YYYY';

BEGIN
   v_stage := 'initialize variables';
   v_parms := '~Parms'
      ||  ': p_in_languageCode >' || p_in_languageCode
      || '<, p_in_rowNumEnd >' || p_in_rowNumEnd
      || '<, p_in_rowNumStart >' || p_in_rowNumStart
      || '<, p_in_parentNodeId >' || p_in_parentNodeId
      || '<, p_in_promotionId >' || p_in_promotionId
      || '<, p_in_budgetStatus >' || p_in_budgetStatus
      || '<, p_in_budgetDistribution >' || p_in_budgetDistribution
      || '<, p_in_countryRatio >' || p_in_countryRatio              
      || '<, p_in_sortedOn >' || p_in_sortedOn
      || '<, p_in_sortedBy >' || p_in_sortedBy
      || '<';
   
 
   BEGIN                                                                    
     SELECT (budget_media_value / p_in_countryRatio)
      INTO v_budget_media_value  
      FROM country c      
     WHERE c.cm_asset_code ='country_data.country.usa';                       
   END;                                                                     
   
   -- stage input lists
   v_stage := 'stage input lists';
   DELETE gtt_id_list;
   pkg_report_common.p_stage_search_criteria(NVL(p_in_parentNodeId, pkg_report_common.f_get_root_node), gc_ref_text_parent_node_id, 1); 
   pkg_report_common.p_stage_search_criteria(NVL(p_in_budgetStatus, gc_search_all_values), gc_ref_text_budget_status);
   pkg_report_common.p_stage_search_criteria(NVL(p_in_promotionId, gc_search_all_values), gc_ref_text_promotion_id, 1);
   
   v_stage := 'OPEN p_out_data';
   OPEN p_out_data FOR 
   WITH w_budget AS
    ( -- build initial data set
      SELECT bp.promotion_id AS promo_id
           , bp.budget_master_id
           , mv_pn.cms_value   AS promo_name
           , mv_bm.cms_value   AS budget_master_name 
           , bp.distribution_type
           , TO_CHAR (bud.start_date, v_localeDatePattern)
             || ' To '
             || NVL( TO_CHAR(bud.end_date, v_localeDatePattern), ' No End Date ') AS budget_period
           , btd.budget_trans_type
           , btd.trans_amount
           , rnk
     FROM budget_segment bb
          , rpt_budget_promotion bp
          ,(SELECT RANK() OVER(PARTITION BY budget_id ORDER BY budget_history_id ) rnk, r.*
              FROM rpt_budget_trans_detail r) btd
          , rpt_budget_usage_detail bud
          , promotion p
          , gtt_id_list gil_b  -- budget status
          , gtt_id_list gil_p  -- promotion
          , mv_cms_asset_value mv_pn
          , mv_cms_asset_value mv_bm
    WHERE bb.budget_segment_id = btd.budget_segment_id
      AND btd.budget_id = bp.budget_id
      AND bp.distribution_type = NVL(p_in_budgetDistribution, bp.distribution_type)
      AND btd.budget_id = bud.budget_id
      AND ( bud.node_id IN
                ( -- get child nodes based on input parent node(s)
                  SELECT child_node_id
                    FROM rpt_hierarchy_rollup hr,
                         gtt_id_list gil_hr -- hierarchy rollup
                   WHERE gil_hr.ref_text_1 = gc_ref_text_parent_node_id
                     AND gil_hr.id = hr.node_id 
                )
             OR ( bud.budget_owner_type = 'promotion'
                AND bud.node_id IS NULL)
           )
      AND gil_p.ref_text_1 = gc_ref_text_promotion_id
      AND (  gil_p.ref_text_2 = gc_search_all_values
            OR gil_p.id = bp.promotion_id )
      AND gil_b.ref_text_1 = gc_ref_text_budget_status
      AND (  gil_b.ref_text_2 = gc_search_all_values
            OR gil_b.ref_text_2 = btd.budget_status )
      AND bp.promotion_id = p.promotion_id
      AND ((p_in_promotionId IS NULL AND p.promotion_status IN('live','expired')) 
      OR (p_in_promotionId IS NOT NULL AND p.promotion_status = 'live'))
      AND p.promo_name_asset_code        = mv_pn.asset_code (+)
      AND gc_cms_key_fld_promotion_name  = mv_pn.key (+)
      AND p_in_languageCode              = mv_pn.locale (+) 
      AND bud.budget_name_cm_asset_code  = mv_bm.asset_code (+)
      AND gc_cms_key_fld_bud_master_name = mv_bm.key (+)
      AND p_in_languageCode              = mv_bm.locale (+) 
     )
   SELECT s.*
     FROM ( -- sequence the data
            SELECT rd.*,
                   -- calc record sort order
                   ROW_NUMBER() OVER (ORDER BY rd.awarded DESC, LOWER(rd.budget_master_name)) AS rec_seq
              FROM ( -- transform data into the full result set
                     SELECT ds.budget_master_name,
                            ROUND(ds.awarded * v_budget_media_value,0) AS awarded
                       FROM ( -- build initial data set
                              SELECT promo_id
                                           , budget_master_id
                                           , promo_name
                                           , budget_master_name 
                                           , budget_period
                                           , SUM(CASE WHEN budget_trans_type = 'expenditure' 
                                                      THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END) AS awarded
                                      FROM w_budget
                                     WHERE distribution_type <> 'shared'
                                     GROUP BY promo_id
                                           , budget_master_id
                                           , promo_name
                                           , budget_master_name 
                                           , budget_period
                                     UNION ALL
                                    SELECT 0 AS promo_id
                                           , wb.budget_master_id
                                           , wl.promo_name
                                           , wb.budget_master_name 
                                           , wb.budget_period
                                           , SUM(CASE WHEN budget_trans_type = 'expenditure' 
                                                      THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END) AS awarded
                                      FROM (SELECT budget_master_id
                                                   , budget_master_name 
                                                   , budget_period
                                                   , budget_trans_type
                                                   , SUM(trans_amount) trans_amount         --04/15/2019
                                                   , rnk
                                              FROM w_budget 
                                             WHERE distribution_type = 'shared'
                                             GROUP BY budget_master_id
                                                   , budget_master_name 
                                                   , budget_period
                                                   , budget_trans_type
                                                   --, trans_amount                         --04/15/2019
                                                   , rnk
                                            ) wb,
                                           (SELECT budget_master_id
                                                    , LISTAGG(promo_name,' ~ ')  WITHIN GROUP (ORDER BY promo_name) AS promo_name
                                               FROM (SELECT budget_master_id, promo_name 
                                                       FROM w_budget
                                                      WHERE distribution_type = 'shared'
                                                      GROUP BY budget_master_id, promo_name)
                                              GROUP BY budget_master_id
                                           ) wl
                                     WHERE wb.budget_master_id = wl.budget_master_id
                                     GROUP BY 0, wb.budget_master_id
                                           , wl.promo_name
                                           , wb.budget_master_name 
                                           , wb.budget_period
                            ) ds
                   ) rd -- full result set
          ) s -- sort number result set
    ORDER BY s.rec_seq;

   p_out_return_code := '00';

EXCEPTION
   WHEN OTHERS THEN
      p_out_return_code := '99';
      prc_execution_log_entry (c_process_name, 1, 'ERROR', v_stage || SQLERRM || v_parms, NULL);
      OPEN p_out_data FOR SELECT NULL FROM DUAL;
END prc_getUseInPointsChart;

PROCEDURE prc_getUseByPercentageChart(
    p_in_languageCode       IN VARCHAR,
    p_in_rowNumEnd          IN NUMBER,
    p_in_rowNumStart        IN NUMBER,
    p_in_parentNodeId       IN VARCHAR,
    p_in_promotionId        IN VARCHAR,
    p_in_budgetStatus       IN VARCHAR,
    p_in_budgetDistribution IN VARCHAR,
    p_in_countryRatio       IN NUMBER,   
    p_in_sortedOn           IN VARCHAR,
    p_in_sortedBy           IN VARCHAR,
    p_out_return_code       OUT NUMBER,
    p_out_data              OUT SYS_REFCURSOR)
IS
/******************************************************************************
  NAME: prc_getUseByPercentageChart
  Date          Author           Description
  ----------    ---------------  ------------------------------------------------
  12/15/2016    nagarajs          Initial Creation - G5.6.3.3 Budget Redesign
  04/15/2019    Suresh J         Bug 79030 - Mismatch in displaying the Awarded amount between Summary and detail
  ******************************************************************************/
  c_process_name        CONSTANT execution_log.process_name%TYPE := 'prc_getUseByPercentageChart' ;
  v_stage               execution_log.text_line%TYPE;
  v_parms               execution_log.text_line%TYPE;
  v_localeDatePattern   VARCHAR2(50) := 'MM/DD/YYYY';

BEGIN
   v_stage := 'initialize variables';
   v_parms := '~Parms'
      ||  ': p_in_languageCode >' || p_in_languageCode
      || '<, p_in_rowNumEnd >' || p_in_rowNumEnd
      || '<, p_in_rowNumStart >' || p_in_rowNumStart
      || '<, p_in_parentNodeId >' || p_in_parentNodeId
      || '<, p_in_promotionId >' || p_in_promotionId
      || '<, p_in_budgetStatus >' || p_in_budgetStatus
      || '<, p_in_budgetDistribution >' || p_in_budgetDistribution
      || '<, p_in_countryRatio >' || p_in_countryRatio              
      || '<, p_in_sortedOn >' || p_in_sortedOn
      || '<, p_in_sortedBy >' || p_in_sortedBy
      || '<';                                                                 
   
   -- stage input lists
   v_stage := 'stage input lists';
   DELETE gtt_id_list;
   pkg_report_common.p_stage_search_criteria(NVL(p_in_parentNodeId, pkg_report_common.f_get_root_node), gc_ref_text_parent_node_id, 1); 
   pkg_report_common.p_stage_search_criteria(NVL(p_in_budgetStatus, gc_search_all_values), gc_ref_text_budget_status);
   pkg_report_common.p_stage_search_criteria(NVL(p_in_promotionId, gc_search_all_values), gc_ref_text_promotion_id, 1);
   
   v_stage := 'OPEN p_out_data';
   OPEN p_out_data FOR 
   WITH w_budget AS
    ( -- build initial data set
      SELECT bp.promotion_id AS promo_id
           , bp.budget_master_id
           , mv_pn.cms_value   AS promo_name
           , mv_bm.cms_value   AS budget_master_name 
           , bp.distribution_type
           , TO_CHAR (bud.start_date, v_localeDatePattern)
             || ' To '
             || NVL( TO_CHAR(bud.end_date, v_localeDatePattern), ' No End Date ') AS budget_period
           , btd.budget_trans_type
           , btd.trans_amount
           , rnk
     FROM budget_segment bb
          , rpt_budget_promotion bp
          ,(SELECT RANK() OVER(PARTITION BY budget_id ORDER BY budget_history_id ) rnk, r.*
              FROM rpt_budget_trans_detail r) btd
          , rpt_budget_usage_detail bud
          , promotion p
          , gtt_id_list gil_b  -- budget status
          , gtt_id_list gil_p  -- promotion
          , mv_cms_asset_value mv_pn
          , mv_cms_asset_value mv_bm
    WHERE bb.budget_segment_id = btd.budget_segment_id
      AND btd.budget_id = bp.budget_id
      AND bp.distribution_type = NVL(p_in_budgetDistribution, bp.distribution_type)
      AND btd.budget_id = bud.budget_id
      AND ( bud.node_id IN
                ( -- get child nodes based on input parent node(s)
                  SELECT child_node_id
                    FROM rpt_hierarchy_rollup hr,
                         gtt_id_list gil_hr -- hierarchy rollup
                   WHERE gil_hr.ref_text_1 = gc_ref_text_parent_node_id
                     AND gil_hr.id = hr.node_id 
                )
             OR ( bud.budget_owner_type = 'promotion'
                AND bud.node_id IS NULL)
           )
      AND gil_p.ref_text_1 = gc_ref_text_promotion_id
      AND (  gil_p.ref_text_2 = gc_search_all_values
            OR gil_p.id = bp.promotion_id )
      AND gil_b.ref_text_1 = gc_ref_text_budget_status
      AND (  gil_b.ref_text_2 = gc_search_all_values
            OR gil_b.ref_text_2 = btd.budget_status )
      AND bp.promotion_id = p.promotion_id
      AND ((p_in_promotionId IS NULL AND p.promotion_status IN('live','expired')) 
      OR (p_in_promotionId IS NOT NULL AND p.promotion_status = 'live'))
      AND p.promo_name_asset_code        = mv_pn.asset_code (+)
      AND gc_cms_key_fld_promotion_name  = mv_pn.key (+)
      AND p_in_languageCode              = mv_pn.locale (+) 
      AND bud.budget_name_cm_asset_code  = mv_bm.asset_code (+)
      AND gc_cms_key_fld_bud_master_name = mv_bm.key (+)
      AND p_in_languageCode              = mv_bm.locale (+) 
     )
   SELECT s.*
     FROM ( -- sequence the data
            SELECT rd.*,
                   -- calc record sort order
                   ROW_NUMBER() OVER (ORDER BY rd.percent_used DESC, LOWER(rd.budget_master_name)) AS rec_seq
              FROM ( -- transform data into the full result set
                     SELECT ds.budget_master_name,
                            DECODE(ds.budget_amount,0,0,ROUND((ds.awarded/budget_amount) * 100,2)) AS percent_used
                       FROM ( SELECT r.budget_master_name,
                                     (r.original_budget + (r.budget_adjustments - r.original_budget) ) budget_amount,
                                     r.awarded
                               FROM ( -- build initial data set
                                      SELECT promo_id
                                           , budget_master_id
                                           , promo_name
                                           , budget_master_name 
                                           , budget_period
                                           , (SUM(CASE WHEN budget_trans_type = 'deposit'  AND rnk = 1
                                                  THEN NVL(trans_amount, 0)
                                                  ELSE 0
                                                  END)) AS original_budget
                                           , SUM(CASE WHEN budget_trans_type = 'expenditure' 
                                                      THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END) AS awarded
                                           , SUM(CASE WHEN budget_trans_type IN ( 'deposit', 'transfer')
                                                      THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END) AS budget_adjustments
                                      FROM w_budget
                                     WHERE distribution_type <> 'shared'
                                     GROUP BY promo_id
                                           , budget_master_id
                                           , promo_name
                                           , budget_master_name 
                                           , budget_period
                                     UNION ALL
                                    SELECT 0 AS promo_id
                                           , wb.budget_master_id
                                           , wl.promo_name
                                           , wb.budget_master_name 
                                           , wb.budget_period
                                           , (SUM(CASE WHEN budget_trans_type = 'deposit'  AND rnk = 1
                                                              THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END)) AS original_budget
                                           , SUM(CASE WHEN budget_trans_type = 'expenditure' 
                                                      THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END) AS awarded
                                           , SUM(CASE WHEN budget_trans_type IN ( 'deposit', 'transfer')
                                                      THEN NVL(trans_amount, 0)
                                                 ELSE 0
                                                END) AS budget_adjustments
                                      FROM (SELECT budget_master_id
                                                   , budget_master_name 
                                                   , budget_period
                                                   , budget_trans_type
                                                   , SUM(trans_amount) AS trans_amount  --04/15/2019
                                                   , rnk
                                              FROM w_budget 
                                             WHERE distribution_type = 'shared'
                                             GROUP BY budget_master_id
                                                   , budget_master_name 
                                                   , budget_period
                                                   , budget_trans_type
                                                   --, trans_amount             --04/15/2015
                                                   , rnk
                                            ) wb,
                                           (SELECT budget_master_id
                                                    , LISTAGG(promo_name,' ~ ')  WITHIN GROUP (ORDER BY promo_name) AS promo_name
                                               FROM (SELECT budget_master_id, promo_name 
                                                       FROM w_budget
                                                      WHERE distribution_type = 'shared'
                                                      GROUP BY budget_master_id, promo_name)
                                              GROUP BY budget_master_id
                                           ) wl
                                     WHERE wb.budget_master_id = wl.budget_master_id
                                     GROUP BY 0, wb.budget_master_id
                                           , wl.promo_name
                                           , wb.budget_master_name 
                                           , wb.budget_period
                                   ) r
                           )ds -- initial data set
                   ) rd -- full result set
          ) s -- sort number result set
    ORDER BY s.rec_seq;

   p_out_return_code := '00';

EXCEPTION
   WHEN OTHERS THEN
      p_out_return_code := '99';
      prc_execution_log_entry (c_process_name, 1, 'ERROR', v_stage || SQLERRM || v_parms, NULL);
      OPEN p_out_data FOR SELECT NULL FROM DUAL;
END prc_getUseByPercentageChart;

END pkg_query_point_budget_balance;