#! /usr/bin/python
def load_mhex(caffe_prototxt, caffe_model, mhex_mat_file, save_file, load_mat1=True, load_mat2=True):
  """
  load matrices dumped from matlab into Caffe network
  MHEX implemenatation in Caffe consists of two InnerProductLayer at bottom and
  top, and one SoftmaxLayer between them.
  The inner product layer below softmax should be named "mhex_mat1", and 
  The inner product layer above softmax should be named "mhex_mat2".
  """
  import numpy as np, scipy.io
  import caffe

  # load architecture for pure Caffe net and the fine-tuned model
  caffe.set_mode_cpu()
  if len(caffe_model) > 0:
    net = caffe.Net(caffe_prototxt, caffe_model)
  else
    net = caffe.Net(caffe_prototxt)

  # load R-CNN model weights and scalings
  mat = scipy.io.loadmat(mhex_mat_file)
  M1, M2 = mat['M1'], mat['M2']

  # Caffe requires 4 dimensions
  M1 = M1[np.newaxis, np.newaxis, :, :]
  M2 = M2[np.newaxis, np.newaxis, :, :]

  # coerce to C-contiguous memory for Caffe
  # (numpy makes it seem to be so already, but its illusory: check .flags)
  M1 = np.ascontiguousarray(M1)
  M2 = np.ascontiguousarray(M2)

  # transplant SVMs into fc-rcnn. [0] is weight matrix, [1] is bias
  if load_mat1:
    net.params['mhex_mat1'][0].data[...] = M1
    net.params['mhex_mat1'][1].data[...] = 0
  if load_mat2:
    net.params['mhex_mat2'][0].data[...] = M2
    net.params['mhex_mat2'][1].data[...] = 0

  # save
  net.save(save_file)
