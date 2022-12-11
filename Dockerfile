# installed package lists : 
# 1. opencv (full package)
# 2. matplotlib with korean lang
# 3. numpy (default)
# 4. pandas (default)
# 5. sklearn (default)
# 6. seaborn (default)

FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/jupyter-tensorflow-cuda-full:v1.5.0

ENV NB_USER jovyan
ENV HOME /home/$NB_USER
ENV NB_PREFIX /

# apt-key authentication
USER root
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC

# matplotlib korean font setting
RUN apt install -y apt-utils
RUN apt install -y fonts-nanum*
RUN cp /usr/share/fonts/truetype/nanum/Nanum* /usr/share/fonts/truetype/dejavu/
RUN cp /usr/share/fonts/truetype/nanum/Nanum* /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/fonts/ttf/

# install opencv
RUN apt update
RUN apt install -y libopencv-dev

USER jovyan
RUN pip install opencv-contrib-python

# install keras-cv
RUN pip install keras-cv --upgrade

# upgrade scikit-learn
RUN pip3 uninstall -y scikit-learn
RUN pip3 install -U scikit-learn 

# upgrade numpy
RUN pip uninstall -y numpy
RUN pip install numpy 

# upgrade pandas
RUN pip uninstall -y pandas
RUN pip install pandas

# upgrade seaborn
RUN pip uninstall -y seaborn
RUN pip install seaborn 

EXPOSE 8888

CMD ["sh","-c", "jupyter notebook --notebook-dir=${HOME} --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]
