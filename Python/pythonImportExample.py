import scipy.io
import numpy as np
import matplotlib.pyplot as plt
import os
import glob

# Dataset file path:
dataset_path = r"C:\...\savedData\Topologies"

# Option 1: Load in a single file from the dataset and extract the topology and solution data
# Update the file path to the .mat file as needed

specified_file_path = r"\X\1_X_441.mat"
mat_data = scipy.io.loadmat(dataset_path + specified_file_path)

# Extract all the data in the .mat file
imageNames = mat_data['dataset'][0,:]['imageName']
topologies = mat_data['dataset'][0,:]['topology']
solutions = mat_data['dataset'][0,:]['solution']

# Option 2: Loop through all the files in the dataset and extract the topology and solution data for each file
mat_files = sorted(glob.glob(os.path.join(dataset_path, '**', '*.mat'), recursive=True))
all_image_names = []
all_topologies = []
all_solutions = []

for mat_file in mat_files:
    mat = scipy.io.loadmat(mat_file)
    dataset_entries = mat['dataset'][0, :]
    for entry in dataset_entries:
        all_image_names.append(entry['imageName'][0])
        all_topologies.append(entry['topology'][:,:])
        all_solutions.append(entry['solution'][:,:])

combined_image_names = np.array(all_image_names, dtype=object)
combined_topologies = np.stack(all_topologies, axis=0)
combined_solutions = np.stack(all_solutions, axis=0)

# Use combined arrays instead of single-file arrays
imageNames = combined_image_names
topologies = combined_topologies
solutions = combined_solutions

selectionIdx = 1

topology = topologies[selectionIdx,]
solution = solutions[selectionIdx,]
S = solution['S'][0,0]
F = solution['Freq'][0,0]
Z = solution['Zref'][0,0]

# Plot the binary array
plt.imshow(topology, cmap='summer', interpolation='nearest')
plt.title('32x32 Grid Data')
plt.show()

S11 = S[0,0,:]
S12 = S[0,1,:]

# Plot the magnitude of S11 and S12
plt.plot(F,20*np.log10(np.abs(S11)), label='|S11|')
plt.plot(F,20*np.log10(np.abs(S12)), label='|S12|')
plt.xlabel('Frequency (Hz)')
plt.ylabel('Magnitude (dB)')
plt.title('Magnitude of S11 and S12')
plt.legend()
plt.show()