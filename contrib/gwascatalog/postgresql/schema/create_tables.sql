DROP TABLE IF EXISTS GwasCatalog;
CREATE TABLE GwasCatalog (
    date_added                     date,
    pubmed_id                      integer  not null,
    first_author                   varchar  not null,
    date_published                 date     not null,
    journal                        varchar  not null,
    pubmed_url                     varchar  not null,
    study_title                    varchar  not null,
    disease_or_trait               varchar  not null,
    initial_sample                 varchar  not null,
    replication_sample             varchar,
    region                         varchar,
    chrom_reported                 varchar(32),
    pos_reported                   integer,
    gene_reported                  varchar,
    gene_mapped                    varchar,
    upstream_entrez_gene_id        varchar,
    downstream_entrez_gene_id      varchar,
    entrez_gene_id                 varchar,
    upstream_gene_distance_kb      real,
    downstream_gene_distance_kb    real,
    strongest_snp_risk_allele      varchar,
    strongest_snps                 varchar,
    is_snp_id_merged               boolean,
    snp_id_current                 varchar,
    snp_context                    varchar,
    is_snp_intergenic              boolean,
    risk_allele_freq_reported      real,
    p_value                        numeric,
    minus_log_p_value              real,
    p_value_text                   varchar,
    odds_ratio_or_beta_coeff       real,
    confidence_interval_95_percent varchar,
    snp_platform                   varchar,
    cnv                            varchar,
    snp_id                         integer,
    risk_allele                    varchar(1024),
    date_downloaded                date     not null,
    UNIQUE (date_downloaded, pubmed_id, disease_or_trait, snp_id, risk_allele)
);