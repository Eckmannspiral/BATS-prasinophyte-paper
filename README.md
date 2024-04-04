# BATS-prasinophyte-paper
Code used for statistics and figure generation

If there are any issues with this information please report them and I will be happy to take a look.

Files used to generate most of the datafiles used in stats and figures:

v1v2_dataset_import_v6.R:
rep_cyano_plastid_seqs.fasta.aln.jplace.tab
rep_viridi_seqs.fasta.aln.jplace.tab2.txt
rep_strameno_seqs.fasta.aln.jplace.tab
rep_pelago_seqs.fasta.aln.jplace.tab
rep_dictyo_seqs.fasta.aln.jplace.tab
feature_table.tsv
BATS_BS_COMBINED_MASTER_2021.12.17.xlsx
bats_pigments.xlsx
bats_bottle.xlsx
BATS_PP_2016_2020.xlsx
2016_to_2019_ctd_data.xlsx (this file is too big to upload but is downloaded from https://bats.bios.asu.edu/bats-data/)

BATS_counts_v4_chl.Rmd:
feature_table_taxPA.tsv

Figure-by-figure information:

Figure 1:
a. Circles on map: bats_map.Rmd, locations_df7.csv
b. Temperature plot: odv_v4.Rmd, v1v2_dataset_import_v6.R
c. Chlorophyll plot: odv_v4.Rmd, v1v2_dataset_import_v6.R
d. Prasinophyte of plastid plot: odv_v4.Rmd, v1v2_dataset_import_v6.R

Figure 2:
heatmaps_v3.Rmd, counts_together5_metadata_prasinos.csv, dcm_and_dm_samples_v2.csv, surface_samples.csv, dcm_dm_data_percents_transposed.tsv, surface_data_percents_transposed.tsv, surface_fluo_percent_prasino.tsv, dcm_fluo_percent_prasino.tsv

Figure 3:
a. chl_euk_scatter_v3, counts_together5_metadata_prasinos.csv
b. circle_v2.Rmd, counts_together5_metadata_prasinos.csv

Figure 4:
asv_odv_v3.Rmd, data from BATS_counts_v4_chl.Rmd

Figure 5:
cca_v5.Rmd, all_asvs_summary_metadata.tsv, vetted_real_prasinos.csv

Figure 6:
figure6_reclassified_v8.Rmd, v1v2_dataset_import_v6.R, false_prasinos.csv

Figure S1:
odv_v4.Rmd, v1v2_dataset_import_v6.R

Figure S2:

Figure S3:
cand1_calculations_v2.Rmd, archeaplastida.xlsx, metadata_ciliates.xlsx, feature_table_taxPA.tsv, false_prasinos.csv, BATS_BS_COMBINED_MASTER_2021.12.17.xlsx
cand2_calculations_v3.Rmd, a1_strict_calculations.Rmd

Figure S4:

Figure S5:
a. ticker_graphs_mld.Rmd
b. figure6_reclassified_v8.Rmd, v1v2_dataset_import_v6.R, false_prasinos.csv

Figure S6:
asv_odv_v3.Rmd, data from BATS_counts_v4_chl.Rmd

Figure S7:
cca_v4_chl.Rmd, all_asvs_summary_metadata.tsv, vetted_real_prasinos.csv

Figure S8:
rarefraction_all_asvs_v2.Rmd, BATS_BS_COMBINED_MASTER_2021.12.17_cae.xlsx, paper_samples.csv, feature_table.tsv

Figure S9:
rarefraction_all_asvs_plastid_only.Rmd, BATS_BS_COMBINED_MASTER_2021.12.17_cae.xlsx, paper_samples.csv, feature_table.tsv

Statistics information:

Averages, standard deviations, Kruskal-Wallis and Dunn tests, and Spearman correlations:
seasonal_enviro_averages_v5.Rmd, v1v2_dataset_import_v6.R
seasonal_prasinophyte_averages_v4.Rmd, counts_together5_metadata_prasinos.csv

ANOSIM:
hellinger_anosim_v3.Rmd, feature_table_taxPA.tsv, vetted_real_prasinos.csv, bats_table_s1_v10.csv


