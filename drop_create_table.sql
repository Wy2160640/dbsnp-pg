-- ftp.ncbi.nih.gov:/snp/database/shared_schema/dbSNP_main_table.sql.gz
--                                             /dbSNP_main_index.sql.gz
--                                             /dbSNP_main_constraint.sql.gz

-- CREATE TABLE [Allele]
-- (
-- [allele_id] [int] IDENTITY(1,1) NOT NULL ,
-- [allele] [varchar](1024) NOT NULL ,
-- [create_time] [smalldatetime] NOT NULL ,
-- [rev_allele_id] [int] NULL ,
-- [src] [varchar](10) NULL ,
-- [last_updated_time] [smalldatetime] NULL ,
-- [allele_left] [varchar](900) NULL
-- )
--
-- CREATE NONCLUSTERED INDEX [i_rev_allele_id] ON [Allele] ([rev_allele_id] ASC)
--
-- ALTER TABLE [Allele] ADD CONSTRAINT [df_Allele_create_time] DEFAULT (GETDATE()) FOR [create_time]
-- ALTER TABLE [Allele] ADD CONSTRAINT [df_Allele_update_time] DEFAULT (GETDATE()) FOR [last_updated_time]
-- ALTER TABLE [Allele] ADD CONSTRAINT [pk_Allele]  PRIMARY KEY  CLUSTERED ([allele_id] ASC)
DROP TABLE IF EXISTS Allele;
CREATE TABLE Allele (
       allele_id          serial         primary key,  -- 1,2,3,...
       allele             varchar(1024)  not null,
       create_time        timestamp      default CURRENT_TIMESTAMP,
       rev_allele_id      integer,
       src                varchar(10),
       last_updated_time  timestamp      default CURRENT_TIMESTAMP,
       allele_left        varchar(900)
);
CREATE INDEX i_rev_allele_id ON Allele (rev_allele_id);

-- CREATE TABLE [SnpChrCode]
-- (
-- [code] [varchar](8) NOT NULL ,
-- [abbrev] [varchar](20) NOT NULL ,
-- [descrip] [varchar](255) NOT NULL ,
-- [create_time] [smalldatetime] NOT NULL ,
-- [sort_order] [tinyint] NULL ,
-- [db_name] [varchar](32) NULL ,
-- [NC_acc] [varchar](16) NULL
-- )
DROP TABLE IF EXISTS SnpChrCode;
CREATE TABLE SnpChrCode (
       code             varchar(8)      primary key,
       abbrev           varchar(20)     not null,
       descrip          varchar(255)    not null,
       create_time      timestamp       not null,
       sort_order       smallint,
       db_name          varchar(32),
       NC_acc           varchar(16)
);


-- ftp.ncbi.nih.gov:/snp/organisms/human_9606/database/organism_schema/human_9606_table.sql.gz
--                                                                    /human_9606_index.sql.gz
--                                                                    /human_9606_constraint.sql.gz

--
-- DROP TABLE IF EXISTS SNPHistory;
-- CREATE TABLE SNPHistory (
--        snp_id          integer  primary key,
--        create_time     timestamp,
--        last_updated_time        timestamp,
--        history_create_time      timestamp,
--        sometext1                 text,
--        sometext2                 text
-- );

-- CREATE TABLE [RsMergeArch]                 -- refSNP(rs) cluster is based on unique genome position. On new genome assembly, previously different contig may
--                                               align. So different rs clusters map to the same location. In this case, we merge the rs. This table tracks this merging.
-- (
-- [rsHigh] [int] NOT NULL ,                  -- Since rs# is assigned sequentially. Low number means the rs occurs early. So we always merge high rs number into low rs number.
-- [rsLow] [int] NOT NULL ,
-- [build_id] [int] NULL ,                    -- dbSNP build id when this rsHigh was merged into rsLow.
-- [orien] [tinyint] NULL ,                   -- The orientation between rsHigh and rsLow.
-- [create_time] [datetime] NOT NULL ,
-- [last_updated_time] [datetime] NOT NULL ,
-- [rsCurrent] [int] NULL ,
-- [orien2Current] [tinyint] NULL ,
-- [comment] [varchar](255) NULL
-- )
--
-- CREATE CLUSTERED INDEX [i_rsH] ON [RsMergeArch] ([rsHigh] ASC)
-- CREATE NONCLUSTERED INDEX [i_rsL] ON [RsMergeArch] ([rsLow] ASC)
DROP TABLE IF EXISTS RsMergeArch;
CREATE TABLE RsMergeArch (
       rsHigh            integer        primary key,
       rsLow             integer,
       build_id          smallint,
       orien             bit,
       create_time       timestamp,
       last_updated_time timestamp,
       rsCurrent         integer        not null,
       orien2Current     bit,
       sometext1         text
);
CREATE INDEX i_rsL ON RsMergeArch (rsLow);

-- CREATE TABLE [b141_SNPChrPosOnRef]  -- This table stores the chromosome position(0 based) of uniquely mapped snp on NCBI reference assembly. It has one
--                                        row for each snp in SNP table. For snp with ambiguous mappings(weight>1, please see SNPMapInfo for weight
--                                        description), the chromosome position is NULL. To get the positions of ambiguous mapped snp, please see
--                                        SNPContigLoc.
--                                        Please note that the actually table name in database has dbSNP build prefix and NCBI genome build suffix. For ex.
--                                        human dbSNP build 130 maps to NCBI 36.3. The table name for this build is: b130_SNPChrPosOnRef_36_3.
-- (
-- [snp_id] [int] NOT NULL ,           -- snp_id refers to SNP.snp_id. Also called 'rs#'.
-- [chr] [varchar](32) NOT NULL ,      -- chr refers to SnpChrCode. Please see value at: ftp://ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz
-- [pos] [int] NULL ,                  -- pos is the 0 based chromosome position of uniquely mapped snp. This value is from SNPContigLoc.phys_pos_from field. Not uniquely mapped snp(weight>1) has NULL in this field.
-- [orien] [int] NULL ,                -- snp to chromosome orientation. 0 - same orientation(orsame strand), 1 - opposite strand
-- [neighbor_snp_list] [int] NULL ,    -- Internal use.
-- [isPAR] [varchar](1) NOT NULL       -- The snp is in Pseudoautosomal Region (PAR) region when isPAR value is 'y'.
-- )
DROP TABLE IF EXISTS b141_SNPChrPosOnRef;
CREATE TABLE b141_SNPChrPosOnRef (
       snp_id                    integer,
       chr                       varchar(32)    not null,
       pos                       integer,
       orien                     bit,
       neighbor_snp_list         integer,
       isPAR                     varchar(1)     not null
);
CREATE UNIQUE INDEX b141_SNPChrPosOnRef_ukey_rs ON b141_SNPChrPosOnRef (snp_id);
CREATE INDEX b141_SNPChrPosOnRef_chr_pos ON b141_SNPChrPosOnRef (chr, pos);

-- CREATE TABLE [Population]                   -- Population is defined and submitted by submitter over their samples.
-- (
-- [pop_id] [int] NOT NULL ,                   -- unique dbSNP population id
-- [handle] [varchar](20) NOT NULL ,           -- "Submitter handle, foreign key to Submitter table."
-- [loc_pop_id] [varchar](64) NOT NULL ,       -- submitter defined population name
-- [loc_pop_id_upp] [varchar](64) NOT NULL ,   -- Upper case obs for indexing and comparison.
-- [create_time] [smalldatetime] NULL ,
-- [last_updated_time] [smalldatetime] NULL ,
-- [src_id] [int] NULL
-- )
--
-- CREATE NONCLUSTERED INDEX [i_handle_loc_pop_id_upp] ON [Population] ([handle] ASC,[loc_pop_id_upp] ASC)
-- CREATE NONCLUSTERED INDEX [i_handle_loc_pop_id] ON [Population] ([handle] ASC,[loc_pop_id] ASC)
--
-- ALTER TABLE [Population] ADD CONSTRAINT [pk_Population_pop_id]  PRIMARY KEY  CLUSTERED ([pop_id] ASC)
DROP TABLE IF EXISTS Population;
CREATE TABLE Population (
       pop_id            integer      primary key,
       handle            varchar(20)  not null,
       loc_pop_id        varchar(64),  -- not null,
       loc_pop_id_upp    varchar(64),  -- not null,
       create_time       timestamp,
       last_updated_time timestamp,
       src_id            integer
);
CREATE INDEX i_handle_loc_pop_id_upp ON Population (handle, loc_pop_id_upp);
CREATE INDEX i_handle_loc_pop_id ON Population (handle, loc_pop_id);

-- CREATE TABLE [AlleleFreqBySsPop]
-- (
-- [subsnp_id] [int] NOT NULL ,
-- [pop_id] [int] NOT NULL ,
-- [allele_id] [int] NOT NULL ,
-- [source] [varchar](2) NOT NULL ,
-- [cnt] [real] NULL ,
-- [freq] [real] NULL ,
-- [last_updated_time] [datetime] NOT NULL
-- )
--
-- ALTER TABLE [AlleleFreqBySsPop] ADD CONSTRAINT [pk_AlleleFreqBySsPop_b129]  PRIMARY KEY  CLUSTERED ([subsnp_id] ASC,[pop_id] ASC,[allele_id] ASC)
DROP TABLE IF EXISTS AlleleFreqBySsPop;
CREATE TABLE AlleleFreqBySsPop (
       subsnp_id               integer     not null,
       pop_id                  integer     not null,
       allele_id               integer     not null,
       source                  varchar(2)  not null,
       cnt                     real,
       freq                    real,
       last_updated_time       timestamp   not null,
       PRIMARY KEY (subsnp_id, pop_id, allele_id)
);

-- CREATE TABLE [SNPSubSNPLink]                -- This is the central table that keeps the relationship between submitted snp and reference snp.
-- (
-- [subsnp_id] [int] NULL ,                    -- Submitted snp(subsnp) id. This is foreign key to SubSNP table. Each submitted snp will get a reference snp cluster id after we blast the subsnp flanking sequence against contig.
-- [snp_id] [int] NULL ,                       -- "refSNP cluster id. The submitted snp cluster together if they map to the same contig position, or if they have similar flanking sequence."
-- [substrand_reversed_flag] [tinyint] NULL ,  -- 0 means the submitted snp(subsnp) is in the same orientation as the refSNP. 1 means subsnp is in reverse orientation to refSNP.
-- [create_time] [datetime] NULL ,
-- [last_updated_time] [datetime] NULL ,
-- [build_id] [int] NULL ,                     -- dbSNP build id the last change to the subsnp linking record occurred.
-- [comment] [varchar](255) NULL
-- )
--
-- CREATE CLUSTERED INDEX [i_ss] ON [SNPSubSNPLink] ([subsnp_id] ASC)
-- CREATE NONCLUSTERED INDEX [i_rs] ON [SNPSubSNPLink] ([snp_id] ASC,[subsnp_id] ASC,[substrand_reversed_flag] ASC)
--
-- ALTER TABLE [SNP] ADD CONSTRAINT [fk_exem_ss_2link] FOREIGN KEY (exemplar_subsnp_id) REFERENCES [SNPSubSNPLink](subsnp_id)
DROP TABLE IF EXISTS SNPSubSNPLink;
CREATE TABLE SNPSubSNPLink (
       subsnp_id           integer,
       snp_id              integer,
       substrand_reversed_flag  bit,  -- 0: same, 1: reverse
       create_time              timestamp,
       last_updated_time        timestamp,
       build_id                 integer,
       comment                  varchar(255)
);
CREATE INDEX i_ss ON SNPSubSNPLink (subsnp_id);
CREATE INDEX i_rs ON SNPSubSNPLink (snp_id, subsnp_id, substrand_reversed_flag);

-- CREATE TABLE [SNPAlleleFreq]             -- This table stores the average allele frequency for a refSNP(rs#).
-- (
-- [snp_id] [int] NOT NULL ,
-- [allele_id] [int] NOT NULL ,             -- Foreign key to Allele table.
-- [chr_cnt] [float] NULL ,                 -- Count of chromosomes for the allele specified in allele_id.
-- [freq] [float] NULL ,                    -- Frequency of this allele.
-- [last_updated_time] [datetime] NOT NULL
-- )
--
-- ALTER TABLE [SNPAlleleFreq] ADD CONSTRAINT [pk_SNPAlleleFreq]  PRIMARY KEY  CLUSTERED ([snp_id] ASC,[allele_id] ASC)
DROP TABLE IF EXISTS SNPAlleleFreq;
CREATE TABLE SNPAlleleFreq (
       snp_id              integer,
       allele_id           integer,
       chr_cnt             real,
       freq                real,
       last_updated_time   timestamp,
       PRIMARY KEY (snp_id, allele_id)
);

-- CREATE TABLE [b141_SNPChrPosOnRef]  -- This table stores the chromosome position(0 based) of uniquely mapped snp on NCBI reference assembly. It has one
--                                        row for each snp in SNP table. For snp with ambiguous mappings(weight>1, please see SNPMapInfo for weight
--                                        description), the chromosome position is NULL. To get the positions of ambiguous mapped snp, please see
--                                        SNPContigLoc.
--                                        Please note that the actually table name in database has dbSNP build prefix and NCBI genome build suffix. For ex.
--                                        human dbSNP build 130 maps to NCBI 36.3. The table name for this build is: b130_SNPChrPosOnRef_36_3.
-- (
-- [snp_id] [int] NOT NULL ,           -- snp_id refers to SNP.snp_id. Also called 'rs#'.
-- [chr] [varchar](32) NOT NULL ,      -- chr refers to SnpChrCode. Please see value at: ftp://ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz
-- [pos] [int] NULL ,                  -- pos is the 0 based chromosome position of uniquely mapped snp. This value is from SNPContigLoc.phys_pos_from field. Not uniquely mapped snp(weight>1) has NULL in this field.
-- [orien] [int] NULL ,                -- snp to chromosome orientation. 0 - same orientation(orsame strand), 1 - opposite strand
-- [neighbor_snp_list] [int] NULL ,    -- Internal use.
-- [isPAR] [varchar](1) NOT NULL       -- The snp is in Pseudoautosomal Region (PAR) region when isPAR value is 'y'.
-- )
DROP TABLE IF EXISTS b141_SNPChrPosOnRef;
CREATE TABLE b141_SNPChrPosOnRef (
       snp_id                    integer          primary key,
       chr                       varchar(32)      not null,
       pos                       integer,
       orien                     bit,
       neighbor_snp_list         integer,
       isPAR                     varchar(1)       not null
);

-- CREATE TABLE [dn_PopulationIndGrp]
-- (
-- [pop_id] [int] NOT NULL ,
-- [ind_grp_name] [varchar](32) NOT NULL ,
-- [ind_grp_code] [tinyint] NOT NULL
-- )
--
-- ALTER TABLE [dn_PopulationIndGrp] ADD CONSTRAINT [pk_dn_PopulationIndGrp]  PRIMARY KEY  CLUSTERED ([pop_id] ASC)
DROP TABLE IF EXISTS dn_PopulationIndGrp;
CREATE TABLE dn_PopulationIndGrp (
       pop_id                    integer          primary key,
       ind_grp_name              varchar(32)      not null,
       ind_grp_code              smallint         not null
);
