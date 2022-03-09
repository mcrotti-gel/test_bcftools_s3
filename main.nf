
Channel
      .fromPath(params.vcf_list)
      .ifEmpty { exit 1, "Cannot find input file : ${params.vcf_list}" }
      .splitCsv(skip:1)
      .map { row -> tuple(row[0], file(row[1]), file(row[2]))}
      .take( params.number_of_files_to_process )
      .set { vcf_input }

process bcftools_view {
	publishDir "${params.outdir}/head", mode: 'copy'

    echo true

    input:
	tuple val(sampleID), val(vcf), val(index) from vcf_input

	output:
	file("${sampleID}_output.txt")

    script:
    """
    bcftools view ${vcf} | head > ${sampleID}_output.txt
    """
}