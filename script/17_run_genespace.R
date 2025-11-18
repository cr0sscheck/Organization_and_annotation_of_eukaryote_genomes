#!/usr/bin/env Rscript
library(GENESPACE)

args <- commandArgs(trailingOnly = TRUE)

# get the folder where the genespace workingDirectory is located
wd <- args[1]

message("[INFO] wd: ", wd)

gpar <- init_genespace(wd = wd, path2mcscanx =  "/usr/local/bin", verbose = TRUE)

# run genespace
out <- run_genespace(gpar, overwrite = TRUE)
pangenome <- query_pangenes(out, bed = NULL, refGenome = "TAIR10", transform = TRUE, showArrayMem = TRUE, showNSOrtho = TRUE, maxMem2Show = Inf)

# save pangenome object as rds
saveRDS(out, file = file.path(wd, "genespace_results.rds"))
saveRDS(pangenome, file = file.path(wd, "pangenome_matrix.rds"))
message("[OK] Saved genespace_results.rds and pangenome_matrix.rds")

# in your next script, you can load the pangenome matrix with:
# pangenome <- readRDS(file.path(wd, "pangenome_matrix.rds"))
# and then use it for downstream analyses, e.g., calculating core, accessory and specific genes
