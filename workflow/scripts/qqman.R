library(qqman)

assoc <- readr::read_tsv(snakemake@input$assoc)

png(snakemake@output$qq, width=512, height=512)
qq(assoc$p_wald)
dev.off()

png(snakemake@output$man, width=1024, height=512)
manhattan(assoc, chr="chr", bp="ps", p="p_wald", snp="rs", ylim=c(0, 10))
dev.off()

