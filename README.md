mongo_agent_align_subset
=====================

[MongoAgent](https://github.com/dmlond/mongo_agent) that wraps [dmlond/bwa_aligner](https://github.com/dmlond/bwa_aligner)

takes the subset_file produced by the split_agent, aligns it to the reference
with bwa, and uses samtools to produce a sorted bam file.

See the [mongo_agent_alignment](https://github.com/dmlond/mongo_agent_alignment)
documentation for more details.

input task: {
  agent_name: 'align_subset_agent',
  parent_id: 'id of the alignment_agent task that this is working on',
  build: 'dirname of build directory in /home/bwa_user/bwa_indexed',
  reference: 'filename of fasta file indexed in /home/bwa_user/bwa_indexed/build',
  raw_file: 'filename of fastq file in /home/bwa_user/data',
  subset: 'filename of a subset of the raw_file produced by split_agent',
  ready: true
}
