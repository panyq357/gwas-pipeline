pheno <- read.table(snakemake@input$pheno)
fam <- read.table(snakemake@input$fam, sep=" ")
fam$V6 <- pheno$V2[match(fam$V1, pheno$V1)]
write.table(fam, snakemake@output$fam, row.names=F, col.names=F, quote=F)
