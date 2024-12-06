GENOMES=['bosTau9', 'canFam6', 'equCab3', 'felCat9', 'galGal6',
         'mm39', 'oviAri4', 'susScr11', 'hg38']

KSIZES=[21, 31, 51]

rule all:
    input:
        expand('output/{g}.sig.zip', g=GENOMES)


rule sketch:
    input:
        'genomes/{g}.fa.gz',
    output:
        'output/{g}.sig.zip',
    params:
        p=",".join([ f'k={k}' for k in KSIZES ]),
    shell: """
        sourmash scripts singlesketch {input} -o {output} \
           --name {wildcards.g} -p {params.p}
    """

rule hg38_download:
    output:
        # last mod on FTP server: Jan 24, 2014; size 983726049 bytes.
        'downloads/hg38.chromFa.tar.gz',
    shell: """
         curl -JL ftp://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.chromFa.tar.gz -o {output}
    """
        
rule hg38_chroms:
    input:
        'downloads/hg38.chromFa.tar.gz',
    output:
        temporary(directory('downloads/hg38')),
    shell: """
        mkdir -p {output}
        tar xvf {input} -C {output}
    """

rule hg38_sketch:
    input:
        dir="downloads/hg38",
    output:
        "output/hg38.sig.zip",
    params:
        fasta = "downloads/hg38/chroms/*",
        p=",".join([ f'k={k}' for k in KSIZES ]),
    shell: """
        sourmash sketch dna -o {output} -p {params.p} {params.fasta}
    """

ruleorder: hg38_sketch > sketch
