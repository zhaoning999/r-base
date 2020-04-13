FROM rpy2/rpy2:2.9.x

# 运行错误，可能是rpy2基础版本原因
# RUN apt-get update \
#   && apt-get install -y libudunits2-dev \
#   && apt-get install -y libgdal-dev

ARG CRAN_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/CRAN/

RUN \
  echo "agricolae\n\
        base\n\
        AlgDesign\n\
        graphics\n\
        grDevices\n\
        DoE.base\n\
        rsm\n\
        Rserve\n\
        ggplot2\n\
        qualityTools\n\
        FrF2\n\
        stats" > rpacks.txt && \
  R -e 'install.packages(sub("(.+)\\\\n","\\1", scan("rpacks.txt", "character")), repos="'"${CRAN_MIRROR}"'",dependencies=TRUE)' && \
  rm rpacks.txt

  # 添加dependency
# R -e "Rserve::run.Rserve(remote=TRUE)"
  
