# Use an official NVIDIA PyTorch image
FROM nvcr.io/nvidia/pytorch:23.09-py3

# Set the default Jupyter Lab password if provided as an environment variable
ENV JUPYTER_PASSWORD=""

# Run Jupyter Lab when the container launches
CMD ["/bin/bash", "-c", "HASHED_PASSWORD=$(python -c \"from notebook.auth import passwd; print(passwd('$JUPYTER_PASSWORD'))\"); echo \"c.NotebookApp.password = u'$HASHED_PASSWORD'\" >> ~/.jupyter/jupyter_notebook_config.py && jupyter lab --no-browser"]