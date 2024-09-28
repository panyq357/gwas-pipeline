
rule bcftools_filter:
    input:
        config["genotype_vcf"]
    output:
        "resources/bcftools_filter.vcf.gz"
    params:
        args = config["bcftools_filter"]
    shell:
        '''
        bcftools view {params.args} {input} | bgzip > {output}
        '''


rule plink_filter:
    input:
        vcf = "resources/bcftools_filter.vcf.gz"
    output:
        bed = "results/plink_filter.bed",
        bim = "results/plink_filter.bim",
        fam = "results/plink_filter.fam"
    params:
        args = config["plink_filter"],
        out_prefix = "results/plink_filter"
    shell:
        '''
        plink1.9 \
            --vcf {input.vcf} \
            {params.args} \
            --make-bed \
            --out {params.out_prefix}
        '''

