-- Copyright (C) 2017-2018 52°North Initiative for
-- Geospatial Open Source Software GmbH
--
-- This program is free software; you can redistribute it and/or modify it
-- under the terms of the GNU General Public License version 2 as published
-- by the Free Software Foundation.
--
-- If the program is linked with libraries which are licensed under one of
-- the following licenses, the combination of the program with the linked
-- library is not considered a "derivative work" of the program:
--
--     - Apache License, version 2.0
--     - Apache Software License, version 1.0
--     - GNU Lesser General Public License, version 3
--     - Mozilla Public License, versions 1.0, 1.1 and 2.0
--     - Common Development and Distribution License (CDDL), version 1.0
--
-- Therefore the distribution of the program linked with libraries licensed
-- under the aforementioned licenses, is permitted by the copyright holders
-- if the distribution is compliant with both the GNU General Public
-- License version 2 and the aforementioned licenses.
--
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
-- Public License for more details.
--
-- \connect template_postgis
-- DROP SCHEMA IF EXISTS tiger CASCADE;
-- DROP SCHEMA IF EXISTS tiger_data CASCADE;
-- DROP SCHEMA IF EXISTS topology CASCADE;
\connect sos
DROP SCHEMA IF EXISTS tiger CASCADE;
DROP SCHEMA IF EXISTS tiger_data CASCADE;
DROP SCHEMA IF EXISTS topology CASCADE;
CREATE TABLE blobvalue (
    observationid bigint NOT NULL,
    value oid
);
CREATE TABLE booleanfeatparamvalue (
    parameterid bigint NOT NULL,
    value character(1),
    CONSTRAINT booleanfeatparamvalue_value_check CHECK ((value = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);
CREATE TABLE booleanparametervalue (
    parameterid bigint NOT NULL,
    value character(1),
    CONSTRAINT booleanparametervalue_value_check CHECK ((value = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);
CREATE TABLE booleanvalue (
    observationid bigint NOT NULL,
    value character(1),
    CONSTRAINT booleanvalue_value_check CHECK ((value = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT booleanvalue_value_check1 CHECK ((value = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);
CREATE TABLE categoryfeatparamvalue (
    parameterid bigint NOT NULL,
    value character varying(255),
    unitid bigint
);
CREATE TABLE categoryparametervalue (
    parameterid bigint NOT NULL,
    value character varying(255),
    unitid bigint
);
CREATE TABLE categoryvalue (
    observationid bigint NOT NULL,
    value character varying(255),
    identifier character varying(255),
    name character varying(255),
    description character varying(255)
);
CREATE TABLE codespace (
    codespaceid bigint NOT NULL,
    codespace character varying(255) NOT NULL
);
CREATE TABLE complexvalue (
    observationid bigint NOT NULL
);
CREATE TABLE compositeobservation (
    observationid bigint NOT NULL,
    childobservationid bigint NOT NULL
);
CREATE TABLE compositephenomenon (
    parentobservablepropertyid bigint NOT NULL,
    childobservablepropertyid bigint NOT NULL
);
CREATE TABLE countfeatparamvalue (
    parameterid bigint NOT NULL,
    value integer
);
CREATE TABLE countparametervalue (
    parameterid bigint NOT NULL,
    value integer
);
CREATE TABLE countvalue (
    observationid bigint NOT NULL,
    value integer
);
CREATE TABLE featureofinterest (
    featureofinterestid bigint NOT NULL,
    hibernatediscriminator character varying(255),
    featureofinteresttypeid bigint NOT NULL,
    identifier character varying(255),
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    geom geometry,
    descriptionxml text,
    url character varying(255)
);
CREATE TABLE featureofinteresttype (
    featureofinteresttypeid bigint NOT NULL,
    featureofinteresttype character varying(255) NOT NULL
);
CREATE TABLE featureparameter (
    parameterid bigint NOT NULL,
    featureofinterestid bigint NOT NULL,
    name character varying(255) NOT NULL
);
CREATE TABLE featurerelation (
    parentfeatureid bigint NOT NULL,
    childfeatureid bigint NOT NULL
);
CREATE TABLE geometryvalue (
    observationid bigint NOT NULL,
    value geometry
);
CREATE TABLE numericfeatparamvalue (
    parameterid bigint NOT NULL,
    value double precision,
    unitid bigint
);
CREATE TABLE numericparametervalue (
    parameterid bigint NOT NULL,
    value double precision,
    unitid bigint
);
CREATE TABLE numericvalue (
    observationid bigint NOT NULL,
    value double precision
);
CREATE TABLE observableproperty (
    observablepropertyid bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    disabled character(1) DEFAULT 'F'::bpchar NOT NULL,
    hiddenchild character(1) DEFAULT 'F'::bpchar NOT NULL,
    CONSTRAINT observableproperty_disabled_check CHECK ((disabled = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT observableproperty_hiddenchild_check CHECK ((hiddenchild = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);
CREATE TABLE observation (
    observationid bigint NOT NULL,
    seriesid bigint NOT NULL,
    phenomenontimestart timestamp without time zone NOT NULL,
    phenomenontimeend timestamp without time zone NOT NULL,
    resulttime timestamp without time zone NOT NULL,
    identifier character varying(255),
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    deleted character(1) DEFAULT 'F'::bpchar NOT NULL,
    child character(1) DEFAULT 'F'::bpchar NOT NULL,
    parent character(1) DEFAULT 'F'::bpchar NOT NULL,
    validtimestart timestamp without time zone,
    validtimeend timestamp without time zone,
    samplinggeometry geometry,
    unitid bigint,
    CONSTRAINT observation_child_check CHECK ((child = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT observation_deleted_check CHECK ((deleted = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT observation_parent_check CHECK ((parent = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);
CREATE TABLE observationconstellation (
    observationconstellationid bigint NOT NULL,
    observablepropertyid bigint NOT NULL,
    procedureid bigint NOT NULL,
    observationtypeid bigint,
    offeringid bigint NOT NULL,
    deleted character(1) DEFAULT 'F'::bpchar NOT NULL,
    hiddenchild character(1) DEFAULT 'F'::bpchar NOT NULL,
    disabled character(1) DEFAULT 'F'::bpchar NOT NULL,
    CONSTRAINT observationconstellation_deleted_check CHECK ((deleted = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT observationconstellation_disabled_check CHECK ((disabled = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT observationconstellation_hiddenchild_check CHECK ((hiddenchild = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);
CREATE TABLE observationhasoffering (
    observationid bigint NOT NULL,
    offeringid bigint NOT NULL
);
CREATE TABLE observationtype (
    observationtypeid bigint NOT NULL,
    observationtype character varying(255) NOT NULL
);
CREATE TABLE offering (
    offeringid bigint NOT NULL,
    hibernatediscriminator character(1) NOT NULL,
    identifier character varying(255) NOT NULL,
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    disabled character(1) DEFAULT 'F'::bpchar NOT NULL,
    CONSTRAINT offering_disabled_check CHECK ((disabled = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);
CREATE TABLE offeringallowedfeaturetype (
    offeringid bigint NOT NULL,
    featureofinteresttypeid bigint NOT NULL
);
CREATE TABLE offeringallowedobservationtype (
    offeringid bigint NOT NULL,
    observationtypeid bigint NOT NULL
);
CREATE TABLE offeringhasrelatedfeature (
    relatedfeatureid bigint NOT NULL,
    offeringid bigint NOT NULL
);
CREATE TABLE offeringrelation (
    parentofferingid bigint NOT NULL,
    childofferingid bigint NOT NULL
);
CREATE TABLE parameter (
    parameterid bigint NOT NULL,
    observationid bigint NOT NULL,
    name character varying(255) NOT NULL
);
CREATE TABLE procedure (
    procedureid bigint NOT NULL,
    hibernatediscriminator character(1) NOT NULL,
    proceduredescriptionformatid bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    deleted character(1) DEFAULT 'F'::bpchar NOT NULL,
    disabled character(1) DEFAULT 'F'::bpchar NOT NULL,
    descriptionfile text,
    referenceflag character(1) DEFAULT 'F'::bpchar,
    typeof bigint,
    istype character(1) DEFAULT 'F'::bpchar,
    isaggregation character(1) DEFAULT 'T'::bpchar,
    mobile character(1) DEFAULT 'F'::bpchar,
    insitu character(1) DEFAULT 'T'::bpchar,
    CONSTRAINT procedure_deleted_check CHECK ((deleted = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT procedure_disabled_check CHECK ((disabled = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT procedure_insitu_check CHECK ((insitu = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT procedure_isaggregation_check CHECK ((isaggregation = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT procedure_istype_check CHECK ((istype = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT procedure_mobile_check CHECK ((mobile = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT procedure_referenceflag_check CHECK ((referenceflag = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);
CREATE TABLE proceduredescriptionformat (
    proceduredescriptionformatid bigint NOT NULL,
    proceduredescriptionformat character varying(255) NOT NULL
);
CREATE TABLE profileobservation (
    observationid bigint NOT NULL,
    childobservationid bigint NOT NULL
);
CREATE TABLE profilevalue (
    observationid bigint NOT NULL,
    fromlevel double precision,
    tolevel double precision,
    levelunitid bigint
);
CREATE TABLE referencevalue (
    observationid bigint NOT NULL,
    href character varying(255),
    title character varying(255),
    role character varying(255)
);
CREATE TABLE relatedfeature (
    relatedfeatureid bigint NOT NULL,
    featureofinterestid bigint NOT NULL
);
CREATE TABLE relatedfeaturehasrole (
    relatedfeatureid bigint NOT NULL,
    relatedfeatureroleid bigint NOT NULL
);
CREATE TABLE relatedfeaturerole (
    relatedfeatureroleid bigint NOT NULL,
    relatedfeaturerole character varying(255) NOT NULL
);
CREATE TABLE relatedobservation (
    relatedobservationid bigint NOT NULL,
    observationid bigint,
    relatedobservation bigint,
    role character varying(255),
    relatedurl character varying(255)
);
CREATE TABLE resulttemplate (
    resulttemplateid bigint NOT NULL,
    offeringid bigint NOT NULL,
    observablepropertyid bigint NOT NULL,
    procedureid bigint,
    featureofinterestid bigint,
    identifier character varying(255) NOT NULL,
    resultstructure text NOT NULL,
    resultencoding text NOT NULL
);
CREATE TABLE sensorsystem (
    parentsensorid bigint NOT NULL,
    childsensorid bigint NOT NULL
);
CREATE TABLE series (
    seriesid bigint NOT NULL,
    featureofinterestid bigint NOT NULL,
    observablepropertyid bigint NOT NULL,
    procedureid bigint NOT NULL,
    offeringid bigint NOT NULL,
    deleted character(1) DEFAULT 'F'::bpchar NOT NULL,
    published character(1) DEFAULT 'T'::bpchar NOT NULL,
    hiddenchild character(1) DEFAULT 'F'::bpchar NOT NULL,
    firsttimestamp timestamp without time zone,
    lasttimestamp timestamp without time zone,
    firstnumericvalue double precision,
    lastnumericvalue double precision,
    unitid bigint,
    identifier character varying(255),
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    seriestype character varying(255),
    CONSTRAINT series_deleted_check CHECK ((deleted = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT series_hiddenchild_check CHECK ((hiddenchild = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT series_published_check CHECK ((published = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);
CREATE TABLE seriesreference (
    seriesid bigint NOT NULL,
    referenceseriesid bigint NOT NULL,
    sortorder integer NOT NULL
);
CREATE TABLE swedataarrayvalue (
    observationid bigint NOT NULL,
    value text
);
CREATE TABLE textfeatparamvalue (
    parameterid bigint NOT NULL,
    value character varying(255)
);
CREATE TABLE textparametervalue (
    parameterid bigint NOT NULL,
    value character varying(255)
);
CREATE TABLE textvalue (
    observationid bigint NOT NULL,
    value text,
    identifier character varying(255),
    name character varying(255),
    description character varying(255)
);
CREATE TABLE unit (
    unitid bigint NOT NULL,
    unit character varying(255) NOT NULL,
    name character varying(255),
    link character varying(255)
);
CREATE TABLE validproceduretime (
    validproceduretimeid bigint NOT NULL,
    procedureid bigint NOT NULL,
    proceduredescriptionformatid bigint NOT NULL,
    starttime timestamp without time zone NOT NULL,
    endtime timestamp without time zone,
    descriptionxml text NOT NULL
);
CREATE TABLE xmlfeatparamvalue (
    parameterid bigint NOT NULL,
    value text
);
CREATE TABLE xmlparametervalue (
    parameterid bigint NOT NULL,
    value text
);
ALTER TABLE ONLY blobvalue
    ADD CONSTRAINT blobvalue_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY booleanfeatparamvalue
    ADD CONSTRAINT booleanfeatparamvalue_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY booleanparametervalue
    ADD CONSTRAINT booleanparametervalue_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY booleanvalue
    ADD CONSTRAINT booleanvalue_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY categoryfeatparamvalue
    ADD CONSTRAINT categoryfeatparamvalue_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY categoryparametervalue
    ADD CONSTRAINT categoryparametervalue_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY categoryvalue
    ADD CONSTRAINT categoryvalue_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY codespace
    ADD CONSTRAINT codespace_pkey PRIMARY KEY (codespaceid);
ALTER TABLE ONLY codespace
    ADD CONSTRAINT codespaceuk UNIQUE (codespace);
ALTER TABLE ONLY complexvalue
    ADD CONSTRAINT complexvalue_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY compositeobservation
    ADD CONSTRAINT compositeobservation_pkey PRIMARY KEY (observationid, childobservationid);
ALTER TABLE ONLY compositephenomenon
    ADD CONSTRAINT compositephenomenon_pkey PRIMARY KEY (childobservablepropertyid, parentobservablepropertyid);
ALTER TABLE ONLY countfeatparamvalue
    ADD CONSTRAINT countfeatparamvalue_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY countparametervalue
    ADD CONSTRAINT countparametervalue_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY countvalue
    ADD CONSTRAINT countvalue_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featureofinterest_pkey PRIMARY KEY (featureofinterestid);
ALTER TABLE ONLY featureofinteresttype
    ADD CONSTRAINT featureofinteresttype_pkey PRIMARY KEY (featureofinteresttypeid);
ALTER TABLE ONLY featureparameter
    ADD CONSTRAINT featureparameter_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY featurerelation
    ADD CONSTRAINT featurerelation_pkey PRIMARY KEY (childfeatureid, parentfeatureid);
ALTER TABLE ONLY featureofinteresttype
    ADD CONSTRAINT featuretypeuk UNIQUE (featureofinteresttype);
ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featureurl UNIQUE (url);
ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT foiidentifieruk UNIQUE (identifier);
ALTER TABLE ONLY geometryvalue
    ADD CONSTRAINT geometryvalue_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY numericfeatparamvalue
    ADD CONSTRAINT numericfeatparamvalue_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY numericparametervalue
    ADD CONSTRAINT numericparametervalue_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY numericvalue
    ADD CONSTRAINT numericvalue_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY observableproperty
    ADD CONSTRAINT observableproperty_pkey PRIMARY KEY (observablepropertyid);
ALTER TABLE ONLY observation
    ADD CONSTRAINT observation_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT observationconstellation_pkey PRIMARY KEY (observationconstellationid);
ALTER TABLE ONLY observationhasoffering
    ADD CONSTRAINT observationhasoffering_pkey PRIMARY KEY (observationid, offeringid);
ALTER TABLE ONLY observationtype
    ADD CONSTRAINT observationtype_pkey PRIMARY KEY (observationtypeid);
ALTER TABLE ONLY observationtype
    ADD CONSTRAINT observationtypeuk UNIQUE (observationtype);
ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT obsnconstellationidentity UNIQUE (observablepropertyid, procedureid, offeringid);
ALTER TABLE ONLY observableproperty
    ADD CONSTRAINT obspropidentifieruk UNIQUE (identifier);
ALTER TABLE ONLY offering
    ADD CONSTRAINT offering_pkey PRIMARY KEY (offeringid);
ALTER TABLE ONLY offeringallowedfeaturetype
    ADD CONSTRAINT offeringallowedfeaturetype_pkey PRIMARY KEY (offeringid, featureofinteresttypeid);
ALTER TABLE ONLY offeringallowedobservationtype
    ADD CONSTRAINT offeringallowedobservationtype_pkey PRIMARY KEY (offeringid, observationtypeid);
ALTER TABLE ONLY offeringhasrelatedfeature
    ADD CONSTRAINT offeringhasrelatedfeature_pkey PRIMARY KEY (offeringid, relatedfeatureid);
ALTER TABLE ONLY offeringrelation
    ADD CONSTRAINT offeringrelation_pkey PRIMARY KEY (childofferingid, parentofferingid);
ALTER TABLE ONLY offering
    ADD CONSTRAINT offidentifieruk UNIQUE (identifier);
ALTER TABLE ONLY parameter
    ADD CONSTRAINT parameter_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY proceduredescriptionformat
    ADD CONSTRAINT procdescformatuk UNIQUE (proceduredescriptionformat);
ALTER TABLE ONLY procedure
    ADD CONSTRAINT procedure_pkey PRIMARY KEY (procedureid);
ALTER TABLE ONLY proceduredescriptionformat
    ADD CONSTRAINT proceduredescriptionformat_pkey PRIMARY KEY (proceduredescriptionformatid);
ALTER TABLE ONLY procedure
    ADD CONSTRAINT procidentifieruk UNIQUE (identifier);
ALTER TABLE ONLY profileobservation
    ADD CONSTRAINT profileobservation_pkey PRIMARY KEY (observationid, childobservationid);
ALTER TABLE ONLY profilevalue
    ADD CONSTRAINT profilevalue_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY referencevalue
    ADD CONSTRAINT referencevalue_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY relatedfeature
    ADD CONSTRAINT relatedfeature_pkey PRIMARY KEY (relatedfeatureid);
ALTER TABLE ONLY relatedfeaturehasrole
    ADD CONSTRAINT relatedfeaturehasrole_pkey PRIMARY KEY (relatedfeatureid, relatedfeatureroleid);
ALTER TABLE ONLY relatedfeaturerole
    ADD CONSTRAINT relatedfeaturerole_pkey PRIMARY KEY (relatedfeatureroleid);
ALTER TABLE ONLY relatedobservation
    ADD CONSTRAINT relatedobservation_pkey PRIMARY KEY (relatedobservationid);
ALTER TABLE ONLY relatedfeaturerole
    ADD CONSTRAINT relfeatroleuk UNIQUE (relatedfeaturerole);
ALTER TABLE ONLY resulttemplate
    ADD CONSTRAINT resulttemplate_pkey PRIMARY KEY (resulttemplateid);
ALTER TABLE ONLY sensorsystem
    ADD CONSTRAINT sensorsystem_pkey PRIMARY KEY (childsensorid, parentsensorid);
ALTER TABLE ONLY series
    ADD CONSTRAINT series_pkey PRIMARY KEY (seriesid);
ALTER TABLE ONLY series
    ADD CONSTRAINT seriesidentifieruk UNIQUE (identifier);
ALTER TABLE ONLY series
    ADD CONSTRAINT seriesidentity UNIQUE (featureofinterestid, observablepropertyid, procedureid, offeringid);
ALTER TABLE ONLY seriesreference
    ADD CONSTRAINT seriesreference_pkey PRIMARY KEY (seriesid, sortorder);
ALTER TABLE ONLY swedataarrayvalue
    ADD CONSTRAINT swedataarrayvalue_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY textfeatparamvalue
    ADD CONSTRAINT textfeatparamvalue_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY textparametervalue
    ADD CONSTRAINT textparametervalue_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY textvalue
    ADD CONSTRAINT textvalue_pkey PRIMARY KEY (observationid);
ALTER TABLE ONLY unit
    ADD CONSTRAINT unit_pkey PRIMARY KEY (unitid);
ALTER TABLE ONLY unit
    ADD CONSTRAINT unituk UNIQUE (unit);
ALTER TABLE ONLY validproceduretime
    ADD CONSTRAINT validproceduretime_pkey PRIMARY KEY (validproceduretimeid);
ALTER TABLE ONLY xmlfeatparamvalue
    ADD CONSTRAINT xmlfeatparamvalue_pkey PRIMARY KEY (parameterid);
ALTER TABLE ONLY xmlparametervalue
    ADD CONSTRAINT xmlparametervalue_pkey PRIMARY KEY (parameterid);
CREATE INDEX blobvalueidx ON blobvalue USING btree (value);
CREATE INDEX blobvalueobsididx ON blobvalue USING btree (observationid);
CREATE INDEX booleanfeatparamidx ON booleanfeatparamvalue USING btree (value);
CREATE INDEX booleanparamididx ON booleanparametervalue USING btree (parameterid);
CREATE INDEX booleanparamidx ON booleanparametervalue USING btree (value);
CREATE INDEX booleanvalueidx ON booleanvalue USING btree (value);
CREATE INDEX booleanvalueobsididx ON booleanvalue USING btree (observationid);
CREATE INDEX categoryfeatparamidx ON categoryfeatparamvalue USING btree (value);
CREATE INDEX categoryparamididx ON categoryparametervalue USING btree (parameterid);
CREATE INDEX categoryparamidx ON categoryparametervalue USING btree (value);
CREATE INDEX categoryvalueidx ON categoryvalue USING btree (value);
CREATE INDEX categoryvalueobsididx ON categoryvalue USING btree (observationid);
CREATE INDEX complexchildobsididx ON compositeobservation USING btree (childobservationid);
CREATE INDEX complexobsididx ON compositeobservation USING btree (observationid);
CREATE INDEX complexvalueobsididx ON complexvalue USING btree (observationid);
CREATE INDEX countfeatparamidx ON countfeatparamvalue USING btree (value);
CREATE INDEX countparamididx ON countparametervalue USING btree (parameterid);
CREATE INDEX countparamidx ON countparametervalue USING btree (value);
CREATE INDEX countvalueidx ON countvalue USING btree (value);
CREATE INDEX countvalueobsididx ON countvalue USING btree (observationid);
CREATE INDEX featparamnameidx ON featureparameter USING btree (name);
CREATE INDEX featuregeomidx ON featureofinterest USING gist (geom);
CREATE INDEX geometryvalueidx ON geometryvalue USING gist (value);
CREATE INDEX geometryvalueobsididx ON geometryvalue USING btree (observationid);
CREATE INDEX numericparamididx ON numericparametervalue USING btree (parameterid);
CREATE INDEX numericvalueidx ON numericvalue USING btree (value);
CREATE INDEX numericvalueobsididx ON numericvalue USING btree (observationid);
CREATE INDEX obsconstobspropidx ON observationconstellation USING btree (observablepropertyid);
CREATE INDEX obsconstofferingidx ON observationconstellation USING btree (offeringid);
CREATE INDEX obsconstprocedureidx ON observationconstellation USING btree (procedureid);
CREATE INDEX obshasoffobservationidx ON observationhasoffering USING btree (observationid);
CREATE INDEX obshasoffofferingidx ON observationhasoffering USING btree (offeringid);
CREATE INDEX obsphentimeendidx ON observation USING btree (phenomenontimeend);
CREATE INDEX obsphentimestartidx ON observation USING btree (phenomenontimestart);
CREATE INDEX obsresulttimeidx ON observation USING btree (resulttime);
CREATE INDEX obsseriesidx ON observation USING btree (seriesid);
CREATE INDEX paramnameidx ON parameter USING btree (name);
CREATE INDEX profileobsididx ON profileobservation USING btree (observationid, childobservationid);
CREATE INDEX profvalueobsididx ON profilevalue USING btree (observationid);
CREATE INDEX quantityfeatparamidx ON numericfeatparamvalue USING btree (value);
CREATE INDEX quantityparamidx ON numericparametervalue USING btree (value);
CREATE INDEX referenceseriesididx ON seriesreference USING btree (referenceseriesid);
CREATE INDEX referencevalueobsididx ON referencevalue USING btree (observationid);
CREATE INDEX relatedobsobsidx ON relatedobservation USING btree (observationid);
CREATE INDEX relobsobsididx ON relatedobservation USING btree (observationid);
CREATE INDEX relobsrelobsididx ON relatedobservation USING btree (relatedobservation);
CREATE INDEX resulttempeobspropidx ON resulttemplate USING btree (observablepropertyid);
CREATE INDEX resulttempidentifieridx ON resulttemplate USING btree (identifier);
CREATE INDEX resulttempofferingidx ON resulttemplate USING btree (offeringid);
CREATE INDEX resulttempprocedureidx ON resulttemplate USING btree (procedureid);
CREATE INDEX samplinggeomidx ON observation USING gist (samplinggeometry);
CREATE INDEX seriesfeatureidx ON series USING btree (featureofinterestid);
CREATE INDEX seriesididx ON seriesreference USING btree (seriesid);
CREATE INDEX seriesobspropidx ON series USING btree (observablepropertyid);
CREATE INDEX seriesofferingidx ON series USING btree (offeringid);
CREATE INDEX seriesprocedureidx ON series USING btree (procedureid);
CREATE INDEX swedataarryvalueobsididx ON swedataarrayvalue USING btree (observationid);
CREATE INDEX textfeatparamidx ON textfeatparamvalue USING btree (value);
CREATE INDEX textparamididx ON textparametervalue USING btree (parameterid);
CREATE INDEX textparamidx ON textparametervalue USING btree (value);
CREATE INDEX textvalueidx ON textvalue USING btree (value);
CREATE INDEX textvalueobsididx ON textvalue USING btree (observationid);
CREATE INDEX validproceduretimeendtimeidx ON validproceduretime USING btree (endtime);
CREATE INDEX validproceduretimestarttimeidx ON validproceduretime USING btree (starttime);
CREATE INDEX xmlparamididx ON xmlparametervalue USING btree (parameterid);
ALTER TABLE ONLY categoryfeatparamvalue
    ADD CONSTRAINT catfeatparamvalueunitfk FOREIGN KEY (unitid) REFERENCES unit(unitid);
ALTER TABLE ONLY categoryparametervalue
    ADD CONSTRAINT catparamvalueunitfk FOREIGN KEY (unitid) REFERENCES unit(unitid);
ALTER TABLE ONLY booleanfeatparamvalue
    ADD CONSTRAINT featparambooleanvaluefk FOREIGN KEY (parameterid) REFERENCES featureparameter(parameterid);
ALTER TABLE ONLY categoryfeatparamvalue
    ADD CONSTRAINT featparamcategoryvaluefk FOREIGN KEY (parameterid) REFERENCES featureparameter(parameterid);
ALTER TABLE ONLY countfeatparamvalue
    ADD CONSTRAINT featparamcountvaluefk FOREIGN KEY (parameterid) REFERENCES featureparameter(parameterid);
ALTER TABLE ONLY numericfeatparamvalue
    ADD CONSTRAINT featparamnumericvaluefk FOREIGN KEY (parameterid) REFERENCES featureparameter(parameterid);
ALTER TABLE ONLY textfeatparamvalue
    ADD CONSTRAINT featparamtextvaluefk FOREIGN KEY (parameterid) REFERENCES featureparameter(parameterid);
ALTER TABLE ONLY xmlfeatparamvalue
    ADD CONSTRAINT featparamxmlvaluefk FOREIGN KEY (parameterid) REFERENCES featureparameter(parameterid);
ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featurecodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featurecodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featurefeaturetypefk FOREIGN KEY (featureofinteresttypeid) REFERENCES featureofinteresttype(featureofinteresttypeid);
ALTER TABLE ONLY featurerelation
    ADD CONSTRAINT featureofinterestchildfk FOREIGN KEY (childfeatureid) REFERENCES featureofinterest(featureofinterestid);
ALTER TABLE ONLY featurerelation
    ADD CONSTRAINT featureofinterestparentfk FOREIGN KEY (parentfeatureid) REFERENCES featureofinterest(featureofinterestid);
ALTER TABLE ONLY parameter
    ADD CONSTRAINT fk_3v5iovcndi9w0hgh827hcvivw FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY featureparameter
    ADD CONSTRAINT fk_4ps6yv41rwnbu3q0let2v7772 FOREIGN KEY (featureofinterestid) REFERENCES featureofinterest(featureofinterestid);
ALTER TABLE ONLY relatedfeaturehasrole
    ADD CONSTRAINT fk_5fd921q6mnbkc57mgm5g4uyyn FOREIGN KEY (relatedfeatureid) REFERENCES relatedfeature(relatedfeatureid);
ALTER TABLE ONLY offeringallowedfeaturetype
    ADD CONSTRAINT fk_cu8nfsf9q5vsn070o2d3u6chg FOREIGN KEY (offeringid) REFERENCES offering(offeringid);
ALTER TABLE ONLY relatedobservation
    ADD CONSTRAINT fk_g0f0mpuxn3co65uwud4pwxh4q FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY offeringallowedobservationtype
    ADD CONSTRAINT fk_jehw0637hllvta9ao1tqdhrtm FOREIGN KEY (offeringid) REFERENCES offering(offeringid);
ALTER TABLE ONLY relatedobservation
    ADD CONSTRAINT fk_m4nuof4x6w253biuu1r6ttnqc FOREIGN KEY (relatedobservation) REFERENCES observation(observationid);
ALTER TABLE ONLY observationhasoffering
    ADD CONSTRAINT fk_s19siow5aetbwb8ppww4kb96n FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY observation
    ADD CONSTRAINT obscodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY observation
    ADD CONSTRAINT obscodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT obsconstobservationiypefk FOREIGN KEY (observationtypeid) REFERENCES observationtype(observationtypeid);
ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT obsconstobspropfk FOREIGN KEY (observablepropertyid) REFERENCES observableproperty(observablepropertyid);
ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT obsconstofferingfk FOREIGN KEY (offeringid) REFERENCES offering(offeringid);
ALTER TABLE ONLY compositephenomenon
    ADD CONSTRAINT observablepropertychildfk FOREIGN KEY (childobservablepropertyid) REFERENCES observableproperty(observablepropertyid);
ALTER TABLE ONLY compositephenomenon
    ADD CONSTRAINT observablepropertyparentfk FOREIGN KEY (parentobservablepropertyid) REFERENCES observableproperty(observablepropertyid);
ALTER TABLE ONLY blobvalue
    ADD CONSTRAINT observationblobvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY booleanvalue
    ADD CONSTRAINT observationbooleanvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY categoryvalue
    ADD CONSTRAINT observationcategoryvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY compositeobservation
    ADD CONSTRAINT observationchildfk FOREIGN KEY (childobservationid) REFERENCES observation(observationid);
ALTER TABLE ONLY complexvalue
    ADD CONSTRAINT observationcomplexvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY countvalue
    ADD CONSTRAINT observationcountvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY geometryvalue
    ADD CONSTRAINT observationgeometryvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY numericvalue
    ADD CONSTRAINT observationnumericvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY observationhasoffering
    ADD CONSTRAINT observationofferingfk FOREIGN KEY (offeringid) REFERENCES offering(offeringid);
ALTER TABLE ONLY compositeobservation
    ADD CONSTRAINT observationparentfk FOREIGN KEY (observationid) REFERENCES complexvalue(observationid);
ALTER TABLE ONLY profilevalue
    ADD CONSTRAINT observationprofilevaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY referencevalue
    ADD CONSTRAINT observationrefvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY observation
    ADD CONSTRAINT observationseriesfk FOREIGN KEY (seriesid) REFERENCES series(seriesid);
ALTER TABLE ONLY swedataarrayvalue
    ADD CONSTRAINT observationswedataarrayvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY textvalue
    ADD CONSTRAINT observationtextvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);
ALTER TABLE ONLY observation
    ADD CONSTRAINT observationunitfk FOREIGN KEY (unitid) REFERENCES unit(unitid);
ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT obsnconstprocedurefk FOREIGN KEY (procedureid) REFERENCES procedure(procedureid);
ALTER TABLE ONLY observableproperty
    ADD CONSTRAINT obspropcodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY observableproperty
    ADD CONSTRAINT obspropcodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY offering
    ADD CONSTRAINT offcodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY offering
    ADD CONSTRAINT offcodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY offeringrelation
    ADD CONSTRAINT offeringchildfk FOREIGN KEY (childofferingid) REFERENCES offering(offeringid);
ALTER TABLE ONLY offeringallowedfeaturetype
    ADD CONSTRAINT offeringfeaturetypefk FOREIGN KEY (featureofinteresttypeid) REFERENCES featureofinteresttype(featureofinteresttypeid);
ALTER TABLE ONLY offeringallowedobservationtype
    ADD CONSTRAINT offeringobservationtypefk FOREIGN KEY (observationtypeid) REFERENCES observationtype(observationtypeid);
ALTER TABLE ONLY offeringrelation
    ADD CONSTRAINT offeringparenffk FOREIGN KEY (parentofferingid) REFERENCES offering(offeringid);
ALTER TABLE ONLY offeringhasrelatedfeature
    ADD CONSTRAINT offeringrelatedfeaturefk FOREIGN KEY (relatedfeatureid) REFERENCES relatedfeature(relatedfeatureid);
ALTER TABLE ONLY profileobservation
    ADD CONSTRAINT oprofileobschildfk FOREIGN KEY (childobservationid) REFERENCES observation(observationid);
ALTER TABLE ONLY booleanparametervalue
    ADD CONSTRAINT parameterbooleanvaluefk FOREIGN KEY (parameterid) REFERENCES parameter(parameterid);
ALTER TABLE ONLY categoryparametervalue
    ADD CONSTRAINT parametercategoryvaluefk FOREIGN KEY (parameterid) REFERENCES parameter(parameterid);
ALTER TABLE ONLY countparametervalue
    ADD CONSTRAINT parametercountvaluefk FOREIGN KEY (parameterid) REFERENCES parameter(parameterid);
ALTER TABLE ONLY numericparametervalue
    ADD CONSTRAINT parameternumericvaluefk FOREIGN KEY (parameterid) REFERENCES parameter(parameterid);
ALTER TABLE ONLY textparametervalue
    ADD CONSTRAINT parametertextvaluefk FOREIGN KEY (parameterid) REFERENCES parameter(parameterid);
ALTER TABLE ONLY xmlparametervalue
    ADD CONSTRAINT parameterxmlvaluefk FOREIGN KEY (parameterid) REFERENCES parameter(parameterid);
ALTER TABLE ONLY procedure
    ADD CONSTRAINT proccodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY procedure
    ADD CONSTRAINT proccodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY sensorsystem
    ADD CONSTRAINT procedurechildfk FOREIGN KEY (childsensorid) REFERENCES procedure(procedureid);
ALTER TABLE ONLY sensorsystem
    ADD CONSTRAINT procedureparenffk FOREIGN KEY (parentsensorid) REFERENCES procedure(procedureid);
ALTER TABLE ONLY procedure
    ADD CONSTRAINT procprocdescformatfk FOREIGN KEY (proceduredescriptionformatid) REFERENCES proceduredescriptionformat(proceduredescriptionformatid);
ALTER TABLE ONLY profileobservation
    ADD CONSTRAINT profileobsparentfk FOREIGN KEY (observationid) REFERENCES profilevalue(observationid);
ALTER TABLE ONLY profilevalue
    ADD CONSTRAINT profileunitfk FOREIGN KEY (levelunitid) REFERENCES unit(unitid);
ALTER TABLE ONLY numericfeatparamvalue
    ADD CONSTRAINT quanfeatparamvalueunitfk FOREIGN KEY (unitid) REFERENCES unit(unitid);
ALTER TABLE ONLY numericparametervalue
    ADD CONSTRAINT quanparamvalueunitfk FOREIGN KEY (unitid) REFERENCES unit(unitid);
ALTER TABLE ONLY relatedfeaturehasrole
    ADD CONSTRAINT relatedfeatrelatedfeatrolefk FOREIGN KEY (relatedfeatureroleid) REFERENCES relatedfeaturerole(relatedfeatureroleid);
ALTER TABLE ONLY relatedfeature
    ADD CONSTRAINT relatedfeaturefeaturefk FOREIGN KEY (featureofinterestid) REFERENCES featureofinterest(featureofinterestid);
ALTER TABLE ONLY offeringhasrelatedfeature
    ADD CONSTRAINT relatedfeatureofferingfk FOREIGN KEY (offeringid) REFERENCES offering(offeringid);
ALTER TABLE ONLY resulttemplate
    ADD CONSTRAINT resulttemplatefeatureidx FOREIGN KEY (featureofinterestid) REFERENCES featureofinterest(featureofinterestid);
ALTER TABLE ONLY resulttemplate
    ADD CONSTRAINT resulttemplateobspropfk FOREIGN KEY (observablepropertyid) REFERENCES observableproperty(observablepropertyid);
ALTER TABLE ONLY resulttemplate
    ADD CONSTRAINT resulttemplateofferingidx FOREIGN KEY (offeringid) REFERENCES offering(offeringid);
ALTER TABLE ONLY resulttemplate
    ADD CONSTRAINT resulttemplateprocedurefk FOREIGN KEY (procedureid) REFERENCES procedure(procedureid);
ALTER TABLE ONLY series
    ADD CONSTRAINT seriescodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY series
    ADD CONSTRAINT seriescodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);
ALTER TABLE ONLY series
    ADD CONSTRAINT seriesfeaturefk FOREIGN KEY (featureofinterestid) REFERENCES featureofinterest(featureofinterestid);
ALTER TABLE ONLY series
    ADD CONSTRAINT seriesobpropfk FOREIGN KEY (observablepropertyid) REFERENCES observableproperty(observablepropertyid);
ALTER TABLE ONLY series
    ADD CONSTRAINT seriesofferingfk FOREIGN KEY (offeringid) REFERENCES offering(offeringid);
ALTER TABLE ONLY series
    ADD CONSTRAINT seriesprocedurefk FOREIGN KEY (procedureid) REFERENCES procedure(procedureid);
ALTER TABLE ONLY seriesreference
    ADD CONSTRAINT seriesrefreffk FOREIGN KEY (referenceseriesid) REFERENCES series(seriesid);
ALTER TABLE ONLY seriesreference
    ADD CONSTRAINT seriesrefseriesfk FOREIGN KEY (seriesid) REFERENCES series(seriesid);
ALTER TABLE ONLY series
    ADD CONSTRAINT seriesunitfk FOREIGN KEY (unitid) REFERENCES unit(unitid);
ALTER TABLE ONLY procedure
    ADD CONSTRAINT typeoffk FOREIGN KEY (typeof) REFERENCES procedure(procedureid);
ALTER TABLE ONLY validproceduretime
    ADD CONSTRAINT validproceduretimeprocedurefk FOREIGN KEY (procedureid) REFERENCES procedure(procedureid);
ALTER TABLE ONLY validproceduretime
    ADD CONSTRAINT validprocprocdescformatfk FOREIGN KEY (proceduredescriptionformatid) REFERENCES proceduredescriptionformat(proceduredescriptionformatid);

-- create sequences
CREATE SEQUENCE codespaceid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE codespaceid_seq
  OWNER TO postgres;
CREATE SEQUENCE featureofinterestid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE featureofinterestid_seq
  OWNER TO postgres;
CREATE SEQUENCE featureofinteresttypeid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE featureofinteresttypeid_seq
  OWNER TO postgres;
CREATE SEQUENCE observablepropertyid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE observablepropertyid_seq
  OWNER TO postgres;
CREATE SEQUENCE observationconstellationid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE observationconstellationid_seq
  OWNER TO postgres;
CREATE SEQUENCE observationid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE observationid_seq
  OWNER TO postgres;
CREATE SEQUENCE observationtypeid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE observationtypeid_seq
  OWNER TO postgres;
CREATE SEQUENCE offeringid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE offeringid_seq
  OWNER TO postgres;
CREATE SEQUENCE parameterid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE parameterid_seq
  OWNER TO postgres;
CREATE SEQUENCE procdescformatid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE procdescformatid_seq
  OWNER TO postgres;
CREATE SEQUENCE procedureid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE procedureid_seq
  OWNER TO postgres;
CREATE SEQUENCE relatedfeatureid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE relatedfeatureid_seq
  OWNER TO postgres;
CREATE SEQUENCE relatedfeatureroleid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE relatedfeatureroleid_seq
  OWNER TO postgres;
CREATE SEQUENCE relatedobservationid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE relatedobservationid_seq
  OWNER TO postgres;
CREATE SEQUENCE resulttemplateid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE resulttemplateid_seq
  OWNER TO postgres;
CREATE SEQUENCE seriesid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE seriesid_seq
  OWNER TO postgres;
CREATE SEQUENCE unitid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE unitid_seq
  OWNER TO postgres;
CREATE SEQUENCE validproceduretimeid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE validproceduretimeid_seq
  OWNER TO postgres;

CREATE SEQUENCE file_upload_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE file_upload_seq
  OWNER TO postgres;

-- add initial feature type
INSERT INTO featureofinteresttype VALUES (nextval('featureofinteresttypeid_seq'), 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint');

-- create additional tables
CREATE OR REPLACE FUNCTION pseudo_encrypt(VALUE int) returns int AS $$
    DECLARE
    l1 int;
    l2 int;
    r1 int;
    r2 int;
    i int:=0;
    BEGIN
    l1:= (VALUE >> 16) & 65535;
    r1:= VALUE & 65535;
    WHILE i < 3 LOOP
    l2 := r1;
    r2 := l1 # ((((1366 * r1 + 150889) % 714025) / 714025.0) * 32767)::int;
    l1 := l2;
    r1 := r2;
    i := i + 1;
    END LOOP;
    RETURN ((r1 << 16) + l1);
    END;
    $$ LANGUAGE plpgsql strict immutable;
CREATE SEQUENCE rndIdSeq maxvalue 2147483647;

CREATE TABLE ort_data (
  featureofinterestid bigint PRIMARY KEY,
  rndid bigint default pseudo_encrypt(nextval('rndIdSeq')::int),
  lat numeric NOT NULL,
  lon numeric NOT NULL,
  thematik character varying(255) NOT NULL,
  CONSTRAINT data_featureofinterestid_fkey FOREIGN KEY (featureofinterestid)
    REFERENCES featureofinterest (featureofinterestid) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE pns_data (
  featureofinterestid bigint PRIMARY KEY,
  rndid bigint default pseudo_encrypt(nextval('rndIdSeq')::int),
  lat numeric NOT NULL,
  lon numeric NOT NULL,
  CONSTRAINT data_featureofinterestid_fkey FOREIGN KEY (featureofinterestid)
    REFERENCES featureofinterest (featureofinterestid) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE parameter_data (
  observablepropertyid bigint PRIMARY KEY,
  CONSTRAINT data_observablepropertyid_fkey FOREIGN KEY (observablepropertyid)
    REFERENCES observableproperty (observablepropertyid) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE column_metadata (
  columnid character varying(20) NOT NULL,
  prefixid character varying(10) NOT NULL,
  dede character varying(255) NOT NULL,
  CONSTRAINT column_metadata_pkey PRIMARY KEY (columnid, prefixid)
);

CREATE TABLE observablepropertyrelation (
  parentobservablepropertyid bigint NOT NULL,
  childobservablepropertyid bigint NOT NULL,
  CONSTRAINT observablepropertyrealtion_pkey PRIMARY KEY (childobservablepropertyid, parentobservablepropertyid),
  CONSTRAINT observablepropertychildfk FOREIGN KEY (childobservablepropertyid)
    REFERENCES observableproperty (observablepropertyid) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT observablepropertyparentfk FOREIGN KEY (parentobservablepropertyid)
  REFERENCES observableproperty (observablepropertyid) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE probe
(
  id bigint NOT NULL,
  identifier character varying(255) NOT NULL,
  pns_id bigint NOT NULL,
  resulttime timestamp with time zone NOT NULL,
  phenomenontimestart timestamp with time zone NOT NULL,
  phenomenontimeend timestamp with time zone NOT NULL,
  lab character varying(255),
  lab_id character varying(255),
  subprobe character varying(255),
  abfluss_situation character varying(255),
  CONSTRAINT pkey PRIMARY KEY (id),
  CONSTRAINT pns_fkey FOREIGN KEY (pns_id)
    REFERENCES featureofinterest (featureofinterestid) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE probe
  OWNER TO postgres;

CREATE TABLE probe_parameter
(
  probe_id bigint NOT NULL,
  parameter_id bigint NOT NULL,
  pp_unit bigint,
  bg numeric(20,10),
  ng numeric(20,10),
  CONSTRAINT probe_parameter_pkey PRIMARY KEY (probe_id, parameter_id),
  CONSTRAINT probe_parameter_probe_fk FOREIGN KEY (probe_id)
      REFERENCES probe (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT probe_parameter_param_fk FOREIGN KEY (parameter_id)
      REFERENCES parameter_data (observablepropertyid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT parameter_unit_fk FOREIGN KEY (pp_unit)
      REFERENCES unit (unitid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE probe_parameter
  OWNER TO postgres;

CREATE TABLE referenz
(
  id bigint NOT NULL,
  identifier character varying NOT NULL,
  CONSTRAINT referenz_pkey PRIMARY KEY (id),
  CONSTRAINT ref_id_uk UNIQUE (identifier)
);
ALTER TABLE referenz
  OWNER TO postgres;

CREATE TABLE literatur
(
  id bigint NOT NULL,
  referenz_id bigint NOT NULL,
  thematik character varying,
  param_id bigint NOT NULL,
  pns_id bigint NOT NULL,
  untersuchungsbeginn timestamp without time zone NOT NULL,
  untersuchungsende timestamp without time zone NOT NULL,
  CONSTRAINT literatur_pkid PRIMARY KEY (id),
  CONSTRAINT literatur_uk UNIQUE (referenz_id, thematik, param_id, pns_id, untersuchungsbeginn, untersuchungsende),
  CONSTRAINT referenz_fk FOREIGN KEY (referenz_id)
      REFERENCES referenz (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pub_param_fk FOREIGN KEY (param_id)
      REFERENCES observableproperty (observablepropertyid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT pub_pns_fkey FOREIGN KEY (pns_id)
    REFERENCES pns_data (featureofinterestid) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE literatur
  OWNER TO postgres;

CREATE TABLE file_upload
(
  id bigint NOT NULL,
  file_name character varying(255) NOT NULL,
  directory character varying(2) NOT NULL,
  CONSTRAINT file_upload_pkid PRIMARY KEY (id),
  CONSTRAINT file_name_uk UNIQUE (file_name, directory)
);
ALTER TABLE file_upload
  OWNER TO postgres;

CREATE TABLE file_upload_ort
(
  file_upload_id bigint REFERENCES file_upload(id) ON DELETE CASCADE,
  ort_id bigint REFERENCES ort_data(featureofinterestid) ON DELETE RESTRICT
);
ALTER TABLE file_upload_ort
  OWNER TO postgres;

CREATE TABLE file_upload_literatur
(
  file_upload_id bigint REFERENCES file_upload(id) ON DELETE CASCADE,
  literatur_id bigint REFERENCES literatur(id) ON DELETE RESTRICT
);
ALTER TABLE file_upload_literatur
  OWNER TO postgres;

CREATE SEQUENCE referenzid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
CREATE SEQUENCE literaturid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
CREATE SEQUENCE probeid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;


-- insert default data
-- allgemein
INSERT INTO column_metadata VALUES ('identifier', 'global', 'ID');
INSERT INTO column_metadata VALUES ('name', 'global', 'Name');
INSERT INTO column_metadata VALUES ('value', 'global', 'Wert');
INSERT INTO column_metadata VALUES ('param', 'global', 'Parameter');
INSERT INTO column_metadata VALUES ('unit', 'global', 'Einheit');
INSERT INTO column_metadata VALUES ('orts_id', 'global' , 'OrtsID');
INSERT INTO column_metadata VALUES ('param_id', 'global', 'Parameter');
INSERT INTO column_metadata VALUES ('pns_id', 'global', 'PNS_ID');
INSERT INTO column_metadata VALUES ('thematik', 'global', 'Thematik');
INSERT INTO column_metadata VALUES ('subprobe', 'global', 'Teilprobe_von');

-- ort
INSERT INTO column_metadata VALUES ('lat', 'ort', 'lat');
INSERT INTO column_metadata VALUES ('lon', 'ort', 'lon');
-- probenahmestelle
INSERT INTO column_metadata VALUES ('lat', 'pns', 'lat');
INSERT INTO column_metadata VALUES ('lon', 'pns', 'lon');
-- parameter/observableproperty
-- probe
INSERT INTO column_metadata VALUES ('resulttime', 'probe', 'Probenahmedatum');
INSERT INTO column_metadata VALUES ('phenomenontimestart', 'probe', 'Ereignisbeginn');
INSERT INTO column_metadata VALUES ('phenomenontimeend', 'probe', 'Ereignisende');
INSERT INTO column_metadata VALUES ('lab', 'probe', 'Labor');
INSERT INTO column_metadata VALUES ('lab_id', 'probe', 'Labor_Nr');
INSERT INTO column_metadata VALUES ('abfluss_situation', 'probe', 'Abflusssituation');
-- proben/parameter
INSERT INTO column_metadata VALUES ('pro_id', 'pro_para', 'Probe');
INSERT INTO column_metadata VALUES ('pp_unit', 'pro_para', 'Einheit');
INSERT INTO column_metadata VALUES ('bg', 'pro_para', 'BG');
INSERT INTO column_metadata VALUES ('ng', 'pro_para', 'NG');
-- referenz

-- Literatur
INSERT INTO column_metadata VALUES ('referenz_id', 'lit', 'Referenz_ID');
INSERT INTO column_metadata VALUES ('untersuchungsbeginn', 'lit', 'Untersuchungsbeginn');
INSERT INTO column_metadata VALUES ('untersuchungsende', 'lit', 'Untersuchungsende');
