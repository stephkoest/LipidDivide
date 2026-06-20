#!/bin/bash
CPU=35
Q=2
INS=3
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}_cs --cross-strand


Q=3
INS=1
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}

Q=3
INS=1
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}_cs --cross-strand

Q=3
INS=2
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}

Q=3
INS=2
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}_cs --cross-strand

Q=3
INS=3
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}

Q=10
INS=1
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}

Q=10
INS=2
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}

Q=10
INS=3
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}

Q=50
INS=1
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}

Q=50
INS=2
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}

Q=50
INS=3
java -Xmx80g -jar /local/one/software/CSBFinder-S/CSBFinder-S-0.6.3-jar-with-dependencies.jar -in data/archaea_CSBfinder_input.fasta -q $Q -procs $CPU -out TXT -ins ${INS} -e archaea_CSBfinder_q${Q}_ins${INS}
