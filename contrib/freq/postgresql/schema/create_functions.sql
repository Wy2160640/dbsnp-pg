--
CREATE OR REPLACE FUNCTION get_allele_freq(
  _source_id int,
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT allele varchar[],
  OUT freq real[],
  OUT freqx real[]
) RETURNS SETOF RECORD AS $$
BEGIN
  RETURN QUERY (
      SELECT
          a.snp_id,
          a.snp_current,
          f.allele,
          f.freq,
          f.freqx
      FROM
          get_current_rs(_rs) a
          LEFT OUTER JOIN (SELECT af.snp_id, af.allele, af.freq, af.freqx FROM allelefreq af WHERE source_id = _source_id) f ON a.snp_current = f.snp_id  -- f.snp_id have been updated to current while bulk importing
  );
END
$$ LANGUAGE plpgsql;
