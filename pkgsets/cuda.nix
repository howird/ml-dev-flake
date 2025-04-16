{
  lib,
  cudaSupport,
  pkgs-system,
}:
lib.optionals cudaSupport (with pkgs-system.cudaPackages; [
  cuda_cudart
  # cuda_nvcc
  cuda_cupti

  cudnn
  nccl
  libcusparse
  libcurand
  libcusolver
  libcufft
  libcublas

  pkgs-system.linuxPackages.nvidia_x11_vulkan_beta
])
