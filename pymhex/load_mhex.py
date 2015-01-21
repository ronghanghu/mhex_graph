#! /usr/bin/env python3.4
import numpy as np, scipy.io
import caffe

def load_mhex(caffe_prototxt, caffe_model, mhex_mat_file, save_file)
  """
  Load two matrices into MHEX network

  """
  # load architecture for pure Caffe net and the fine-tuned model
  net = caffe.Net(caffe_prototxt, caffe_model)
  net.set_mode_cpu()

  # load R-CNN model weights and scalings
  mat = scipy.io.loadmat(mhex_mat_file)
  M1, M2 = mat['M1'], mat['M2']

  # weights are class x feat in R-CNN, but feat x class in cCaffe, and
  # Caffe requires 4 dimensions
  M1 = M1.transpose()
  M1 = M1.[np.newaxis, np.newaxis, :, :]
  M2 = M2.transpose()
  M2 = M2.[np.newaxis, np.newaxis, :, :]

  # coerce to C-contiguous memory for Caffe
  # (numpy makes it seem to be so already, but its illusory: check .flags)
  M1 = np.ascontiguousarray(M1)
  M2 = np.ascontiguousarray(M2)

  # transplant SVMs into fc-rcnn. [0] is weight matrix, [1] is bias
  net.params['mhex_mat1'][0].data[...] = M1
  net.params['mhex_mat1'][1].data[...] = 0
  net.params['mhex_mat2'][0].data[...] = M2
  net.params['mhex_mat2'][1].data[...] = 0

  # save
  net.save(save_file)