rule kinship:
    input:
        bed = "results/plink_filter.bed",
        bim = "results/plink_filter.bim",
        fam = "results/plink_filter.fam"
    output:
        temp_bed = temp("results/kinship.bed"),
        temp_bim = temp("results/kinship.bim"),
        temp_fam = temp("results/kinship.fam"),
        kinship = "results/kinship.cXX.txt"
    params:
        bfile_prefix = "results/kinship",
        out_dir = "results",
        out_prefix = "kinship"
    shell:
        '''
        ln -s $(realpath {input.bed}) {output.temp_bed}
        ln -s $(realpath {input.bim}) {output.temp_bim}
        sed -E 's/-9/9/g' {input.fam} > {output.temp_fam}

        gemma -bfile {params.bfile_prefix} -gk 1 -outdir {params.out_dir} -o {params.out_prefix}
        '''


rule align_pheno:
    input:
        pheno = lambda w: config["pheno"][w.pheno],
        fam = "results/plink_filter.fam"
    output:
        fam = "results/{pheno}/{pheno}.gemma.fam"
    script:
        "../scripts/align_pheno.R"


rule gemma:
    input:
        bed = "results/plink_filter.bed",
        bim = "results/plink_filter.bim",
        gemma_fam = "results/{pheno}/{pheno}.gemma.fam",
        kinship = "results/kinship.cXX.txt"
    output:
        gemma_bed = temp("results/{pheno}/{pheno}.gemma.bed"),
        gemma_bim = temp("results/{pheno}/{pheno}.gemma.bim"),
        assoc = "results/{pheno}/{pheno}.gemma.assoc.txt"
    params:
        bfile_prefix = "results/{pheno}/{pheno}.gemma",
        out_dir = "results/{pheno}",
        out_prefix = "{pheno}.gemma"
    resources:
        io = 100
    shell:
        '''
        ln -s $(realpath {input.bed}) {output.gemma_bed}
        ln -s $(realpath {input.bim}) {output.gemma_bim}
        gemma -bfile {params.bfile_prefix} -k {input.kinship} -lmm 1 -outdir {params.out_dir} -o {params.out_prefix}
        '''


rule qqman:
    input:
        assoc = "results/{pheno}/{pheno}.gemma.assoc.txt"
    output:
        qq = "results/{pheno}/{pheno}.gemma.qq.png",
        man = "results/{pheno}/{pheno}.gemma.man.png"
    script:
        "../scripts/qqman.R"

