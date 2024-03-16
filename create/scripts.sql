ALTER TABLE JUSTIFICATIVA ADD VLR_ACUM_ANUAL_TENDENCIA NUMBER(18,2);
ALTER TABLE JUSTIFICATIVA ADD VLR_ACUM_ANUAL_ORCADO DECIMAL(18,2);
ALTER TABLE JUSTIFICATIVA ADD TOTAL_ORCADO_PROJETO NUMBER(18,2); 
ALTER TABLE JUSTIFICATIVA ADD TOTAL_TENDENCIA_PROJETO NUMBER(18,2);
ALTER TABLE JUSTIFICATIVA ADD TOTAL_REPLANEJADO_PROJETO NUMBER(18,2);
ALTER TABLE JUSTIFICATIVA ADD VLR_ACUM_ANUAL_REPLAN DECIMAL(18,2); 

ALTER TABLE CLASSIF_JUSTIF ADD des_classif_abrev varchar2(4);
ALTER TABLE CLASSIF_JUSTIF ADD texto_padrao_classif varchar2(255);

CREATE TABLE LOG_AJUSTE_TENDENCIA (
    LOGID NUMBER NOT NULL PRIMARY KEY,
    REQUEST CLOB NOT NULL,
    RESPONSE CLOB NOT NULL,
    CREATEDT DATE DEFAULT SYSDATE
);
/
CREATE OR REPLACE TRIGGER "SERVDESK"."LOG_AJUSTE_TENDENCIA_INS" 
BEFORE INSERT ON LOG_AJUSTE_TENDENCIA
FOR EACH ROW
  WHEN (NEW.LOGID IS NULL) BEGIN
  SELECT SEQ_CONTROLADORA_LOG.NEXTVAL
  INTO   :NEW.LOGID
  FROM   DUAL;
END;
/
CREATE SEQUENCE  "SERVDESK"."SEQ_AJUSTE_TENDENCIA"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;

CREATE TABLE LOG_CLASSIFICACAO_ACUMULADO (
    ID_LOG_CLASSIF INT NOT NULL PRIMARY KEY,
    IDPROJETO INT NOT NULL,
	IDEMPRESA INT NOT NULL,
    DAT_ANOMES DATE NOT NULL,
    REALIZADO_ACUMULADO NUMBER(18,2),
    ORCADO_ACUMULADO NUMBER(18,2),
    VARIACAO_ACUMULADO NUMBER(18,2),    
    ORCADO_POSTERIOR NUMBER(18,2),
    TENDENCIA_POSTERIOR NUMBER(18,2),
    ORCADO_ANUAL NUMBER(18,2),
    TENDENCIA_ANUAL NUMBER(18,2),
    VARIACAO_NEGATIVA CHAR(1),
    TIPO_CLASSIFICACAO CHAR(1),
    DTCRIACAO DATE DEFAULT SYSDATE
);
/
CREATE SEQUENCE  "SERVDESK"."SEQ_LOG_CLASSIF_ACUM"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
/
CREATE OR REPLACE TRIGGER "SERVDESK"."LOG_CLASSIFICACAO_INS" 
BEFORE INSERT ON LOG_CLASSIFICACAO_ACUMULADO
FOR EACH ROW
  WHEN (NEW.ID_LOG_CLASSIF IS NULL) BEGIN
  SELECT SEQ_LOG_CLASSIF_ACUM.NEXTVAL
  INTO   :NEW.ID_LOG_CLASSIF
  FROM   DUAL;
END;
/

ALTER TABLE justif_classif DROP CONSTRAINT JUSTIF_CLASSIF_PK;
DROP INDEX JUSTIF_CLASSIF_PK;
ALTER TABLE justif_classif ADD CONSTRAINT JUSTIF_CLASSIF_PK PRIMARY KEY (empcod, dat_anomes, prjcod, cod_classif, tipo_justificativa, tipo_orcamento);

insert into CLASSIF_JUSTIF values (12,'N�o Or�ado (-)','-','I',to_date('10/05/2017'),'t_antoniojunior',null,null,null,null);
insert into CLASSIF_JUSTIF values (13,'Sem Variacao','-','I',to_date('10/05/2017'),'t_antoniojunior',null,null,'SVAR',null);
commit;

update classif_justif
set des_classif_abrev = 'ECON' -- ECON
where cod_classif = 1;

update classif_justif
set des_classif_abrev = 'CANC' -- CANC
where cod_classif = 2;

update classif_justif
set des_classif_abrev = 'POST' -- POST
where cod_classif = 3;

update classif_justif
set des_classif_abrev = 'GEXE' -- GJEX
where cod_classif = 4;


update classif_justif
set des_classif_abrev = 'RECL' -- RECL
where cod_classif = 5;

update classif_justif
set des_classif_abrev = 'OEXT' -- OREX
where cod_classif = 6;

update classif_justif
set des_classif_abrev = 'ANTI' -- ANTI
where cod_classif = 7;

update classif_justif
set des_classif_abrev = 'GATR' -- GATR
where cod_classif = 8;


update classif_justif
set des_classif_abrev = 'SOBR' -- SOBR
where cod_classif = 9;

update classif_justif
set des_classif_abrev = 'REEN' -- REEN
where cod_classif = 10;

update classif_justif
set des_classif_abrev = 'ALOC', -- ALORC
    sit_classif = 'A'
where cod_classif = 11;

update classif_justif
set des_classif_abrev = 'NOOR', -- NOOR
    sit_classif = 'A'
where cod_classif = 12;
commit;

update classif_justif
set des_classif_abrev = 'SVAR', -- SVAR
    sit_classif = 'A'
where cod_classif = 13;
commit;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Economia'
where cod_classif = 1;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Cancelamento'
where cod_classif = 2;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Posterga��o'
where cod_classif = 3;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Gasto j� executado'
where cod_classif = 4;


update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Reclassifica��o Sa�da'
where cod_classif = 5;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Or�amento Extra'
where cod_classif = 6;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Antecipa��o'
where cod_classif = 7;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Gasto atrasado'
where cod_classif = 8;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Sobrecusto'
where cod_classif = 9;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Reclassifica��o entrada'
where cod_classif = 10;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Al�m do Or�ado'
where cod_classif = 11;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica N�o Or�ado'
where cod_classif = 12;

update classif_justif
set texto_padrao_classif = 'Justificativa autom�tica Sem Varia��o'
where cod_classif = 13;
commit;

