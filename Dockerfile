# build this into a mongo_agent:candidate
# and then build dmlond/mongo_agent_align_subset from mongo_agent_base
# docker build -t mongo_agent:candidate
# docker build -t dmlond/mongo_agent_align_subset ../../mongo_agent_base
FROM dmlond/bwa_aligner
MAINTAINER Darin London <darin.london@duke.edu>

USER root
RUN ["/usr/bin/yum", "install", "-y", "--nogpgcheck", "libyaml", "libyaml-devel", "tar", "make", "gcc", "readline", "readline-devel", "openssl","openssl-devel","libxml2-devel","libxslt","libxslt-devel"]
ADD install_ruby.sh /root/install_ruby.sh
RUN ["chmod", "u+x", "/root/install_ruby.sh"]
RUN ["/root/install_ruby.sh"]
RUN ["/usr/local/bin/gem", "install", "moped"]
RUN ["/usr/local/bin/gem", "install", "mongo_agent"]
ADD align_subset_agent.rb /usr/local/bin/align_subset_agent.rb
RUN ["chmod", "777", "/usr/local/bin/align_subset_agent.rb"]
USER bwa_user
WORKDIR /home/bwa_user
ENTRYPOINT []
CMD ["/user/local/bin/align_subset_agent.rb"]
