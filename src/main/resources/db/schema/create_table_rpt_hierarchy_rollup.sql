CREATE TABLE rpt_hierarchy_rollup
    (
  NODE_ID        NUMBER(18)                     NOT NULL,
  CHILD_NODE_ID  NUMBER(18)                     NOT NULL,
  CREATED_BY     NUMBER(18)                     NOT NULL,
  DATE_CREATED   DATE                           NOT NULL
)
/
CREATE UNIQUE INDEX RPT_HIERARCHY_ROLLUP_IDX2 ON RPT_HIERARCHY_ROLLUP
(CHILD_NODE_ID, NODE_ID)
/
CREATE UNIQUE INDEX RPT_HIERARCHY_ROLLUP_PK ON RPT_HIERARCHY_ROLLUP
(NODE_ID, CHILD_NODE_ID)
/
ALTER TABLE RPT_HIERARCHY_ROLLUP ADD (
  CONSTRAINT RPT_HIERARCHY_ROLLUP_PK
  PRIMARY KEY
  (NODE_ID, CHILD_NODE_ID)
  USING INDEX RPT_HIERARCHY_ROLLUP_PK)
/