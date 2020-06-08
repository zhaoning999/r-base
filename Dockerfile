FROM ubuntu:18.04

MAINTAINER Laurent Gautier <lgautier@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive
ARG CRAN_MIRROR=https://cloud.r-project.org
ARG CRAN_MIRROR_TAG=-cran35

ARG RPY2_CFFI_MODE=BOTH

COPY install_apt.sh /opt/
COPY install_rpacks.sh /opt/
COPY install_pip.sh /opt/

RUN \
  sh /opt/install_apt.sh && \
  sh /opt/install_rpacks.sh && \
  sh /opt/install_pip.sh
  
# Run dev version of rpy2
RUN \
  python3 -m pip --no-cache-dir install https://github.com/rpy2/rpy2/archive/master.zip && \
  rm -rf /root/.cache

ARG CRAN_MIRROR=https://cloud.r-project.org

RUN \
  echo "agricolae\n\
        base\n\
        AlgDesign\n\
        graphics\n\
        grDevices\n\
        DoE.base\n\
        rsm\n\
        Rserve\n\
        gplots\n\
        multcomp\n\
        ggplot2\n\
        qualityTools\n\
        FrF2\n\
        stats" > rpacks.txt && \
  R -e 'install.packages(sub("(.+)\\\\n","\\1", scan("rpacks.txt", "character")), repos="'"${CRAN_MIRROR}"'",dependencies=TRUE)' && \
  rm rpacks.txt

#   # 添加dependency
# # R -e "Rserve::run.Rserve(remote=TRUE)"
# # 基于 ningzhao999/r-base:latest 
# # 新版本存在脚本无法运行问题
# # 安装 plots
# # install.packages('bitops')
# # install.packages('https://cran.r-project.org/src/contrib/Archive/caTools/caTools_1.16.tar.gz',dependencies=TRUE)
# # install.packages('gplots')
# install.packages(,repos=CRAN,dependencies=TRUE)