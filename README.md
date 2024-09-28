A pipeline for GWAS analysis.

## How to run this pipeline

First, run these.

```bash
cp config_template.yaml config.yaml
cp workflow/Snakefile_template workflow/Snakefile
```

Then filling `config.yaml`, and specify the outputs in `workflow/Snakefile`.

Finnaly, run this.

```bash
snakemake --cores 20 --resources io=100
```

