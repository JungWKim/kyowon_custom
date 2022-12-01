FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/jupyter-tensorflow-cuda-full:v1.5.0

ENV NB_USER jovyan
ENV HOME /home/$NB_USER
ENV NB_PREFIX /

# install opencv
USER root
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC
RUN apt-get update
RUN apt-get install -y libopencv-dev

USER jovyan
RUN pip install opencv-python

# matplotlib korean font setting
USER root
RUN apt-get install -y apt-utils
RUN apt-get install -y fonts-nanum*
RUN cp /usr/share/fonts/truetype/nanum/Nanum* /usr/share/fonts/truetype/dejavu/
RUN cp /usr/share/fonts/truetype/nanum/Nanum* /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/fonts/ttf/

EXPOSE 8888

CMD ["sh","-c", "jupyter notebook --notebook-dir=${HOME} --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]