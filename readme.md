![release](https://pantheonscience.github.io/states/release.png)

# Cinema Composable Image Set (CIS) example 

<p align="center">
<img width="750" src="doc/img/diagram.png"/>
</p>
<p align="center">Diagram of workflow in this example.</p>

A repository for examples using `Ascent`, in-situ creation of float data, converted to `Cinema CIS`
databases, and verification. 

Build instructions embedded in this workflow are derived from the Ascent build instructions [here](https://ascent.readthedocs.io/en/latest/BuildingAscent.html). This workflow uses **spack** to build all executables, from a specific commit.

This workflow will pull cached builds from a [E4S](https://e4s-project.github.io/) repository, if they exist
to speed up the build/install of requisite applications. If no cached builds are available, it will use
[spack](https://github.com/spack/spack) to build applications.

<p align="center">
<table>
<tr>
<td><img width="200" src="doc/img/010.png"></td>
<td><img width="200" src="doc/img/100.png"></td>
<td><img width="200" src="doc/img/200.png"></td>
</tr>
</table>
</p>
<p align="center">Images from the resulting Cinema database (used to validate run)</p>

The workflow does the following:

- Creates a [Pantheon](http://pantheonscience.org/) environment and build location
- Clones a specific commit of [Spack](https://github.com/spack/spack)
- Uses `spack` to build [Ascent](https://ascent.readthedocs.io/en/latest/) and set up a coupled app/in-situ workflow
- Runs the workflow to produce float images 
- Converts the output to a [Cinema CIS](https://cinemascience.org) database
- Adds a `Cinema` viewer and a jupyter notebook viewer, and packages up the results.
- Verifies the `Cinema` database

## Using this repository

First, clone the repository, then:

1. edit the `bootstrap.env` file to include your compute allocation ID and workflow path.
2. `./execute` will execute the workflow
