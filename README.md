# solar-cell-gen-alg

Files
---------------

AEP_spherical_2.m

---------------

breadth_first1.m

Determine if conductor 1 voxel is linked to the bottom of the cell by 

neighboring conductor 1 voxels.

Takes a 4D matrix

Returns a 4D matrix with updated (i,j,k,3) property

---------------

cellMutate.m

Determine if a cell in a matrix can be changed to another value

Takes a 4D matrix and three coordinates

Returns the value if possible, or -1 if not possible

---------------

checkNeighbors.m

Check neighbors of a cell for a value

Takes a 4D matrix, three coordinates, and a value

Returns true if found

---------------

CleanEPD.m

---------------

collection_zone_spherical.m

Determines which excited electrons are in the vicinity of the

---------------

collect_e.m

---------------

create_gif.m

---------------

Egen0.m

---------------

Egen1.m

---------------

electron_generated.m

---------------

EPVD1.xlsx

---------------

Fitfn.m

---------------

fitnessFn.m

---------------

generation.m

Generate new generation with the same number of members

Takes a 5D matrix (array of 4D matrices), a tuner for crossovers, and a tuner for mutations

Returns a 5D matrix (array of 4D matrices)

---------------

Lightqd.m

---------------

main.m

Currently empty

---------------

Main1stattempt.asv

---------------

Main1stattempt.m

---------------

matrixMutate.m

Apply mutations to a matrix

Takes a 4D matrix, number of mutations, and a tuner 1-10 that determines proximity of mutations

1 = random arrangement

10 = adjacent mutations

Returns a mutated matrix

---------------

mutation_generation_gif.m

A script that generates a gif showing change in efficiency over generations

---------------

OfC.m

---------------

OpC.m

---------------

Pillar_maker.m

---------------

PlotofExcitedElectrons.m

---------------

print_cell.m

---------------

PVAPF.txt

---------------

QDefussion.asv

---------------

QDefussion.m

---------------

shortProblems.m

---------------

SumEgen.m

---------------

SurfaceoOfExcitedElectrons.m

---------------

System_1.m

---------------

visualize.m

---------------

visualizeElectron.m

---------------

visualize_materials.m

Generate a scatter plot to represent the materials in a matrix, with a different color for each material

Takes a 3D matrix, creates a 3D scatter plot

---------------

voxel.m

