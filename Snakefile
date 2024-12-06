GENOMES=['bosTau9', 'canFam6', 'equCab3', 'felCat9', 'galGal6',
         'mm39', 'oviAri4', 'susScr11']

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
