FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/jupyter-tensorflow-cuda-full:v1.5.0

ENV NB_USER jovyan
ENV HOME /home/$NB_USER
ENV NB_PREFIX /

# apt-key authentication
USER root
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC
RUN apt-get update

# matplotlib korean font setting
RUN apt-get install -y apt-utils
RUN apt-get install -y fonts-nanum*
RUN cp /usr/share/fonts/truetype/nanum/Nanum* /usr/share/fonts/truetype/dejavu/
RUN cp /usr/share/fonts/truetype/nanum/Nanum* /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/fonts/ttf/

# install opencv
RUN apt-get install -y libopencv-dev

USER jovyan
RUN pip install opencv-contrib-python

# upgrade scikit-learn
## sklearn 0.24.2 -> 1.2.0
## numpy 1.22.4 will be installed (require at lease 1.17.3)
RUN pip3 install -U scikit-learn

# upgrade tensorflow-gpu
## tensorflow-gpu 2.5.0 -> 2.11.0
## numpy 1.24.0 will be installed (require at least 1.20.0)
## keras 2.4.3 -> 2.11.0
## Conflict occur (kfp 1.6.3 require 0.9 <= absl-py <= 0.11 but tensorflow-gpu require at least 1.0.0)
RUN pip install -U tensorflow-gpu

# install keras-cv
## keras_cv 0.3.4 will be installed
RUN pip install keras-cv

# upgrade pandas
## pandas 1.2.4 -> 1.5.2
RUN pip install -U pandas

# upgrade seaborn
## seaborn 0.11.1 -> 0.12.1
RUN pip install -U seaborn

USER root
EXPOSE 8888

CMD ["sh","-c", "jupyter notebook --notebook-dir=${HOME} --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]
