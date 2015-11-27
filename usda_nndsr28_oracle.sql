-- =========================================================================================================
-- USDA National Nutrient Database for Standard Reference, Release 28 (http://www.ars.usda.gov/ba/bhnrc/ndl)
-- This file was generated by http://github.com/m5n/nutriana
-- Run this SQL with an account that has admin priviledges, e.g.: sqlplus "/as sysdba" < usda_nndsr28_oracle.sql
-- =========================================================================================================

-- This script assumes you've already set up a database when you installed Oracle.
BEGIN EXECUTE IMMEDIATE 'CREATE USER food IDENTIFIED BY food'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -01920 THEN RAISE; END IF; END;
/
GRANT CONNECT, RESOURCE TO food;
CONNECT food/food;

-- Food Description
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FOOD_DES CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE FOOD_DES (
    NDB_No VARCHAR2(5) NOT NULL,   -- 5-digit Nutrient Databank number that uniquely identifies a food item. If this field is defined as numeric, the leading zero will be lost.
    FdGrp_Cd VARCHAR2(4) NOT NULL,   -- 4-digit code indicating food group to which a food item belongs.
    Long_Desc VARCHAR2(200) NOT NULL,   -- 200-character description of food item.
    Shrt_Desc VARCHAR2(60) NOT NULL,   -- 60-character abbreviated description of food item. Generated from the 200-character description using abbreviations in Appendix A. If short description is longer than 60 characters, additional abbreviations are made.
    ComName VARCHAR2(100),   -- Other names commonly used to describe a food, including local or regional names for various foods, for example, "soda" or "pop" for "carbonated beverages."
    ManufacName VARCHAR2(65),   -- Indicates the company that manufactured the product, when appropriate.
    Survey VARCHAR2(1),   -- Indicates if the food item is used in the USDA Food and Nutrient Database for Dietary Studies (FNDDS) and thus has a complete nutrient profile for the 65 FNDDS nutrients.
    Ref_desc VARCHAR2(135),   -- Description of inedible parts of a food item (refuse), such as seeds or bone.
    Refuse NUMBER(2),   -- Percentage of refuse.
    SciName VARCHAR2(65),   -- Scientific name of the food item. Given for the least processed form of the food (usually raw), if applicable.
    N_Factor NUMBER(4, 2),   -- Factor for converting nitrogen to protein (see p. 12).
    Pro_Factor NUMBER(4, 2),   -- Factor for calculating calories from protein (see p. 13).
    Fat_Factor NUMBER(4, 2),   -- Factor for calculating calories from fat (see p. 13).
    CHO_Factor NUMBER(4, 2)   -- Factor for calculating calories from carbohydrate (see p. 13).
);

-- Nutrient Data
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NUT_DATA CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE NUT_DATA (
    NDB_No VARCHAR2(5) NOT NULL,   -- 5-digit Nutrient Databank number.
    Nutr_No VARCHAR2(3) NOT NULL,   -- Unique 3-digit identifier code for a nutrient .
    Nutr_Val NUMBER(10, 3) NOT NULL,   -- Amount in 100 grams, edible portion (Nutrient values have been rounded to a specified number of decimal places for each nutrient. Number of decimal places is listed in the Nutrient Definition file.).
    Num_Data_Pts NUMBER(5) NOT NULL,   -- Number of data points (previously called Sample_Ct) is the number of analyses used to calculate the nutrient value. If the number of data points is 0, the value was calculated or imputed.
    Std_Error NUMBER(8, 3),   -- Standard error of the mean. Null if cannot be calculated. The standard error is also not given if the number of data points is less than three.
    Src_Cd VARCHAR2(2) NOT NULL,   -- Code indicating type of data.
    Deriv_Cd VARCHAR2(4),   -- Data Derivation Code giving specific information on how the value is determined. This field is populated only for items added or updated starting with SR14.
    Ref_NDB_No VARCHAR2(5),   -- NDB number of the item used to calculate a missing value. Populated only for items added or updated starting with SR14.
    Add_Nutr_Mark VARCHAR2(1),   -- Indicates a vitamin or mineral added for fortification or enrichment. This field is populated for ready-to-eat breakfast cereals and many brand-name hot cereals in food group 8.
    Num_Studies NUMBER(2),   -- Number of studies.
    Min NUMBER(10, 3),   -- Minimum value.
    Max NUMBER(10, 3),   -- Maximum value.
    DF NUMBER(4),   -- Degrees of freedom.
    Low_EB NUMBER(10, 3),   -- Lower 95% error bound.
    Up_EB NUMBER(10, 3),   -- Upper 95% error bound.
    Stat_cmt VARCHAR2(10),   -- Statistical comments. See definitions starting on page 33.
    AddMod_Date date,   -- Indicates when a value was either added to the database or last modified.
    CC VARCHAR2(1)   -- Confidence Code indicating data quality, based on evaluation of sample plan, sample handling, analytical method, analytical quality control, and number of samples analyzed. Not included in this release, but is planned for future releases.
);

-- Weight
BEGIN EXECUTE IMMEDIATE 'DROP TABLE WEIGHT CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE WEIGHT (
    NDB_No VARCHAR2(5) NOT NULL,   -- 5-digit Nutrient Databank number.
    Seq VARCHAR2(2) NOT NULL,   -- Sequence number.
    Amount NUMBER(5, 3) NOT NULL,   -- Unit modifier (for example, 1 in "1 cup").
    Msre_Desc VARCHAR2(84) NOT NULL,   -- Description (for example, cup, diced, and 1-inch pieces).
    Gm_Wgt NUMBER(7, 1) NOT NULL,   -- Gram weight.
    Num_Data_Pts NUMBER(3),   -- Number of data points.
    Std_Dev NUMBER(7, 3)   -- Standard deviation.
);

-- Footnote
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FOOTNOTE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE FOOTNOTE (
    NDB_No VARCHAR2(5) NOT NULL,   -- 5-digit Nutrient Databank number.
    Footnt_No VARCHAR2(4) NOT NULL,   -- Sequence number. If a given footnote applies to more than one nutrient number, the same footnote number is used. As a result, this file cannot be indexed.
    Footnt_Typ VARCHAR2(1) NOT NULL,   -- Type of footnote: D = footnote adding information to the food description; M = footnote adding information to measure description; N = footnote providing additional information on a nutrient value. If the Footnt_typ = N, the Nutr_No will also be filled in.
    Nutr_No VARCHAR2(3),   -- Unique 3-digit identifier code for a nutrient to which footnote applies.
    Footnt_Txt VARCHAR2(200) NOT NULL   -- Footnote text.
);

-- Food Group Description
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FD_GROUP CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE FD_GROUP (
    FdGrp_Cd VARCHAR2(4) NOT NULL,   -- 4-digit code identifying a food group. Only the first 2 digits are currently assigned. In the future, the last 2 digits may be used. Codes may not be consecutive.
    FdGrp_Desc VARCHAR2(60) NOT NULL   -- Name of food group.
);

-- LanguaL Factor
BEGIN EXECUTE IMMEDIATE 'DROP TABLE LANGUAL CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE LANGUAL (
    NDB_No VARCHAR2(5) NOT NULL,   -- 5-digit Nutrient Databank number that uniquely identifies a food item. If this field is defined as numeric, the leading zero will be lost.
    Factor_Code VARCHAR2(5) NOT NULL   -- The LanguaL factor from the Thesaurus
);

-- LanguaL Factors Description
BEGIN EXECUTE IMMEDIATE 'DROP TABLE LANGDESC CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE LANGDESC (
    Factor_Code VARCHAR2(5) NOT NULL,   -- The LanguaL factor from the Thesaurus. Only those codes used to factor the foods contained in the LanguaL Factor file are included in this file
    Description VARCHAR2(140) NOT NULL   -- The description of the LanguaL Factor Code from the thesaurus
);

-- Nutrient Definition
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NUTR_DEF CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE NUTR_DEF (
    Nutr_No VARCHAR2(3) NOT NULL,   -- Unique 3-digit identifier code for a nutrient.
    Units VARCHAR2(7) NOT NULL,   -- Units of measure (mg, g, mcg, and so on).
    Tagname VARCHAR2(20),   -- International Network of Food Data Systems (INFOODS) Tagnames. (INFOODS, 2014.) A unique abbreviation for a nutrient/food component developed by INFOODS to aid in the interchange of data.
    NutrDesc VARCHAR2(60) NOT NULL,   -- Name of nutrient/food component.
    Num_Dec VARCHAR2(1) NOT NULL,   -- Number of decimal places to which a nutrient value is rounded.
    SR_Order NUMBER(6) NOT NULL   -- Used to sort nutrient records in the same order as various reports produced from SR.
);

-- Source Code
BEGIN EXECUTE IMMEDIATE 'DROP TABLE SRC_CD CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE SRC_CD (
    Src_Cd VARCHAR2(2) NOT NULL,   -- 2-digit code.
    SrcCd_Desc VARCHAR2(60) NOT NULL   -- Description of source code that identifies the type of nutrient data.
);

-- Data Derivation Code Description
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DERIV_CD CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE DERIV_CD (
    Deriv_Cd VARCHAR2(4) NOT NULL,   -- Derivation Code.
    Deriv_Desc VARCHAR2(120) NOT NULL   -- Description of derivation code giving specific information on how the value was determined.
);

-- Sources of Data
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DATA_SRC CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE DATA_SRC (
    DataSrc_ID VARCHAR2(6) NOT NULL,   -- Unique number identifying the reference/source.
    Authors VARCHAR2(255),   -- List of authors for a journal article or name of sponsoring organization for other documents.
    Title VARCHAR2(255) NOT NULL,   -- Title of article or name of document, such as a report from a company or trade association.
    Year VARCHAR2(4),   -- Year article or document was published.
    Journal VARCHAR2(135),   -- Name of the journal in which the article was published.
    Vol_City VARCHAR2(16),   -- Volume number for journal articles, books, or reports; city where sponsoring organization is located.
    Issue_State VARCHAR2(5),   -- Issue number for journal article; State where the sponsoring organization is located.
    Start_Page VARCHAR2(5),   -- Starting page number of article/document.
    End_Page VARCHAR2(5)   -- Ending page number of article/document.
);

-- Sources of Data Link
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DATSRCLN CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE DATSRCLN (
    NDB_No VARCHAR2(5) NOT NULL,   -- 5-digit Nutrient Databank number.
    Nutr_No VARCHAR2(3) NOT NULL,   -- Unique 3-digit identifier code for a nutrient.
    DataSrc_ID VARCHAR2(6) NOT NULL   -- Unique ID identifying the reference/source.
);

-- Load data into FOOD_DES
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/FOOD_DES.ctl;
-- Assert all 8789 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM FOOD_DES);
DELETE FROM tmp WHERE c = 8789;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into NUT_DATA
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/NUT_DATA.ctl;
-- Assert all 679045 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM NUT_DATA);
DELETE FROM tmp WHERE c = 679045;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into WEIGHT
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/WEIGHT.ctl;
-- Assert all 15438 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM WEIGHT);
DELETE FROM tmp WHERE c = 15438;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into FOOTNOTE
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/FOOTNOTE.ctl;
-- Assert all 553 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM FOOTNOTE);
DELETE FROM tmp WHERE c = 553;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into FD_GROUP
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/FD_GROUP.ctl;
-- Assert all 25 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM FD_GROUP);
DELETE FROM tmp WHERE c = 25;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into LANGUAL
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/LANGUAL.ctl;
-- Assert all 38301 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM LANGUAL);
DELETE FROM tmp WHERE c = 38301;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into LANGDESC
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/LANGDESC.ctl;
-- Assert all 774 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM LANGDESC);
DELETE FROM tmp WHERE c = 774;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into NUTR_DEF
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/NUTR_DEF.ctl;
-- Assert all 150 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM NUTR_DEF);
DELETE FROM tmp WHERE c = 150;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into SRC_CD
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/SRC_CD.ctl;
-- Assert all 10 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM SRC_CD);
DELETE FROM tmp WHERE c = 10;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into DERIV_CD
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/DERIV_CD.ctl;
-- Assert all 55 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM DERIV_CD);
DELETE FROM tmp WHERE c = 55;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into DATA_SRC
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/DATA_SRC.ctl;
-- Assert all 683 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM DATA_SRC);
DELETE FROM tmp WHERE c = 683;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into DATSRCLN
HOST SQLLDR food/food control=./usda_nndsr28/sqlldr/DATSRCLN.ctl;
-- Assert all 244496 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM DATSRCLN);
DELETE FROM tmp WHERE c = 244496;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Correct data inconsistencies, if any
UPDATE NUT_DATA SET Deriv_Cd = NULL WHERE Deriv_Cd = '';
UPDATE NUT_DATA SET Ref_NDB_No = NULL WHERE Ref_NDB_No = '';
UPDATE FOOTNOTE SET Nutr_No = NULL WHERE Nutr_No = '';

-- Add primary keys
ALTER TABLE FOOD_DES ADD PRIMARY KEY (NDB_No);
ALTER TABLE NUT_DATA ADD PRIMARY KEY (NDB_No, Nutr_No);
ALTER TABLE WEIGHT ADD PRIMARY KEY (NDB_No, Seq);
ALTER TABLE FD_GROUP ADD PRIMARY KEY (FdGrp_Cd);
ALTER TABLE LANGUAL ADD PRIMARY KEY (NDB_No, Factor_Code);
ALTER TABLE LANGDESC ADD PRIMARY KEY (Factor_Code);
ALTER TABLE NUTR_DEF ADD PRIMARY KEY (Nutr_No);
ALTER TABLE SRC_CD ADD PRIMARY KEY (Src_Cd);
ALTER TABLE DERIV_CD ADD PRIMARY KEY (Deriv_Cd);
ALTER TABLE DATA_SRC ADD PRIMARY KEY (DataSrc_ID);
ALTER TABLE DATSRCLN ADD PRIMARY KEY (NDB_No, Nutr_No, DataSrc_ID);

-- Add foreign keys
ALTER TABLE FOOD_DES ADD FOREIGN KEY (FdGrp_Cd) REFERENCES FD_GROUP(FdGrp_Cd);
ALTER TABLE NUT_DATA ADD FOREIGN KEY (NDB_No) REFERENCES FOOD_DES(NDB_No);
ALTER TABLE NUT_DATA ADD FOREIGN KEY (Nutr_No) REFERENCES NUTR_DEF(Nutr_No);
ALTER TABLE NUT_DATA ADD FOREIGN KEY (Src_Cd) REFERENCES SRC_CD(Src_Cd);
ALTER TABLE NUT_DATA ADD FOREIGN KEY (Deriv_Cd) REFERENCES DERIV_CD(Deriv_Cd);
ALTER TABLE NUT_DATA ADD FOREIGN KEY (Ref_NDB_No) REFERENCES FOOD_DES(NDB_No);
ALTER TABLE WEIGHT ADD FOREIGN KEY (NDB_No) REFERENCES FOOD_DES(NDB_No);
ALTER TABLE FOOTNOTE ADD FOREIGN KEY (NDB_No) REFERENCES FOOD_DES(NDB_No);
ALTER TABLE FOOTNOTE ADD FOREIGN KEY (Nutr_No) REFERENCES NUTR_DEF(Nutr_No);
ALTER TABLE LANGUAL ADD FOREIGN KEY (NDB_No) REFERENCES FOOD_DES(NDB_No);
ALTER TABLE LANGUAL ADD FOREIGN KEY (Factor_Code) REFERENCES LANGDESC(Factor_Code);
ALTER TABLE DATSRCLN ADD FOREIGN KEY (NDB_No) REFERENCES FOOD_DES(NDB_No);
ALTER TABLE DATSRCLN ADD FOREIGN KEY (Nutr_No) REFERENCES NUTR_DEF(Nutr_No);
ALTER TABLE DATSRCLN ADD FOREIGN KEY (DataSrc_ID) REFERENCES DATA_SRC(DataSrc_ID);
