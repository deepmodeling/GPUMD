/*
    Copyright 2017 Zheyong Fan, Ville Vierimaa, Mikko Ervasti, and Ari Harju
    This file is part of GPUMD.
    GPUMD is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    GPUMD is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with GPUMD.  If not, see <http://www.gnu.org/licenses/>.
*/

#pragma once
#include "utilities/gpu_vector.cuh"
#include <vector>
class Parameters;

class Dataset
{
public:
  // can be removed:
  float force_std = 1.0f;  // target accuracy of force times 100
  float energy_std = 1.0f; // target accuracy of energy times 100
  float virial_std = 1.0f; // target accuracy of virial times 100

  int Nc;                          // number of configurations
  int N;                           // total number of atoms (sum of Na[])
  int max_Na;                      // number of atoms in the largest configuration
  GPU_Vector<int> Na;              // number of atoms in each configuration
  GPU_Vector<int> Na_sum;          // prefix sum of Na
  std::vector<int> has_virial;     // 1 if has virial for a configuration, 0 otherwise
  GPU_Vector<float> atomic_number; // atomic number (number of protons)
  GPU_Vector<float> r;             // position
  GPU_Vector<float> force;         // force
  GPU_Vector<float> pe;            // potential energy
  GPU_Vector<float> virial;        // per-atom virial tensor
  GPU_Vector<float> h;             // box and inverse box
  GPU_Vector<float> pe_ref;        // reference energy for the whole box
  GPU_Vector<float> virial_ref;    // reference virial for the whole box
  GPU_Vector<float> force_ref;     // reference force
  std::vector<float> error_cpu;    // error in energy, virial, or force
  GPU_Vector<float> error_gpu;     // error in energy, virial, or force
  GPU_Vector<int> NN;              // neighbor number
  GPU_Vector<int> NL;              // neighbor list

  // functions related to initialization
  void read_Nc(FILE*, Parameters& para);
  void read_Na(FILE*);
  void read_train_in(char*, Parameters& para);
  float get_rmse_force(const int, const int);
  float get_rmse_energy(const int, const int);
  float get_rmse_virial(const int, const int);
  void find_neighbor(Parameters& para);
  void make_train_or_test_set(
    Parameters& para, int num, int offset, std::vector<int>& configuration_id, Dataset& train_set);
};