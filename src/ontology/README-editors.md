These notes are for the EDITORS of ecao

This project was created using the [ontology development kit](https://github.com/INCATools/ontology-development-kit). See the site for details.

For more details on ontology management, please see the [OBO tutorial](https://github.com/jamesaoverton/obo-tutorial) or the [Gene Ontology Editors Tutorial](https://go-protege-tutorial.readthedocs.io/en/latest/)

You may also want to read the [GO ontology editors guide](http://go-ontology.readthedocs.org/)

## Requirements

 1. Protege (for editing)
 2. A git client (we assume command line git)
 3. [docker](https://www.docker.com/get-docker) (for managing releases)

## Editors Version

Make sure you have an ID range in the [idranges file](ecao-idranges.owl)

If you do not have one, get one from the maintainer of this repo.

The editors version is [ecao-edit.owl](ecao-edit.owl)

** DO NOT EDIT ecao.obo OR ecao.owl in the top level directory **

[../../ecao.owl](../../ecao.owl) is the release version

To edit, open the file in Protege. First make sure you have the repository cloned, see [the GitHub project](https://github.com/pellst/ecao) for details.

You should discuss the git workflow you should use with the maintainer
of this repo, who should document it here. If you are the maintainer,
you can contact the odk developers for assistance. You may want to
copy the flow an existing project, for example GO: [Gene Ontology
Editors Tutorial](https://go-protege-tutorial.readthedocs.io/en/latest/).

In general, it is bad practice to commit changes to master. It is
better to make changes on a branch, and make Pull Requests.

## ID Ranges

These are stored in the file

 * [ecao-idranges.owl](ecao-idranges.owl)

** ONLY USE IDs WITHIN YOUR RANGE!! **

If you have only just set up this repository, modify the idranges file
	and add yourself or other editors. Note Protege does not read the file
- it is up to you to ensure correct Protege configuration.


### Setting ID ranges in Protege

We aim to put this up on the technical docs for OBO on http://obofoundry.org/

For now, consult the [GO Tutorial on configuring Protege](http://go-protege-tutorial.readthedocs.io/en/latest/Entities.html#new-entities)

## Imports

All import modules are in the [imports/](imports/) folder.

There are two ways to include new classes in an import module

 1. Reference an external ontology class in the edit ontology. In Protege: "add new entity", then paste in the PURL
 2. Add to the imports/ecao_terms.txt file

After doing this, you can run

`./run.sh make all_imports`

to regenerate imports.

Note: the ecao_terms.txt file may include 'starter' classes seeded from
the ontology starter kit. It is safe to remove these.

## Design patterns

You can automate (class) term generation from design patterns by placing DOSDP
yaml file and tsv files under src/patterns. Any pair of files in this
folder that share a name (apart from the extension) are assumed to be
a DOSDP design pattern and a corresponding tsv specifying terms to
add.

Design patterns can be used to maintain and generate complete terms
(names, definitions, synonyms etc) or to generate logical axioms
only, with other axioms being maintained in editors file.  This can be
specified on a per-term basis in the TSV file.

Design pattern docs are checked for validity via Travis, but can be
tested locally using

`./run.sh make patterns`

In addition to running standard tests, this command generates an owl
file (`src/patterns/pattern.owl`), which demonstrates the relationships
between design patterns.

(At the time of writing, the following import statements need to be
added to `src/patterns/pattern.owl` for all imports generated in
`src/imports/*_import.owl`.   This will be automated in a future release.')

To compile design patterns to terms run:

`./run.sh make ../patterns/definitions.owl`

This generates a file (`src/patterns/definitions.owl`).  You then need
to add an import statement to the editor's file to import the
definitions file.


## Release Manager notes

You should only attempt to make a release AFTER the edit version is
committed and pushed, AND the travis build passes.

These instructions assume you have
[docker](https://www.docker.com/get-docker). This folder has a script
[run.sh](run.sh) that wraps docker commands.

to release:

first type

    git branch

to make sure you are on master

    cd src/ontology
    ./build.sh

If this looks good type:

    ./prepare_release.sh

This generates derived files such as ecao.owl and ecao.obo and places
them in the top level (../..).

Note that the versionIRI value automatically will be added, and will
end with YYYY-MM-DD, as per OBO guidelines.

Commit and push these files.

    git commit -a

And type a brief description of the release in the editor window

Finally type:

    git push origin master

IMMEDIATELY AFTERWARDS (do *not* make further modifications) go here:

 * https://github.com/pellst/ecao/releases
 * https://github.com/pellst/ecao/releases/new

__IMPORTANT__: The value of the "Tag version" field MUST be

    vYYYY-MM-DD

The initial lowercase "v" is REQUIRED. The YYYY-MM-DD *must* match
what is in the `owl:versionIRI` of the derived ecao.owl (`data-version` in
ecao.obo). This will be today's date.

This cannot be changed after the fact, be sure to get this right!

Release title should be YYYY-MM-DD, optionally followed by a title (e.g. "january release")

You can also add release notes (this can also be done after the fact). These are in markdown format.
In future we will have better tools for auto-generating release notes.

Then click "publish release"

__IMPORTANT__: NO MORE THAN ONE RELEASE PER DAY.

The PURLs are already configured to pull from github. This means that
BOTH ontology purls and versioned ontology purls will resolve to the
correct ontologies. Try it!

 * http://purl.obolibrary.org/obo/ecao.owl <-- current ontology PURL
 * http://purl.obolibrary.org/obo/ecao/releases/YYYY-MM-DD.owl <-- change to the release you just made

For questions on this contact Chris Mungall or email obo-admin AT obofoundry.org

# Travis Continuous Integration System

Check the build status here: [![Build Status](https://travis-ci.org/pellst/ecao.svg?branch=master)](https://travis-ci.org/pellst/ecao)

Note: if you have only just created this project you will need to authorize travis for this repo.

 1. Go to [https://travis-ci.org/profile/pellst](https://travis-ci.org/profile/pellst)
 2. click the "Sync account" button
 3. Click the tick symbol next to ecao

Travis builds should now be activated

# Configuring ECAO templates

The COVOC vocabulary pipeline is based on Google sheets for curation and ROBOT for
template compilation. This is how its done:

1. Publish a particular sheet on Google sheets (File > Publish on web). In the publishing dialog select the sheet you want to publish and as the file type TSV (not: Web page). Copy the url to the sheet.
2. Go to config.txt and and a row by giving the sheet name, for example `organism` and the url copied in the last step. Use the pipe symbol ('|') to separate the two.
3. Important: Make sure there is exactly one empty row in the end of the file.

When this is done, the release manager will run 

```
cd src/ontology
sh run.sh make prepare_templates
```

To download the pattern files from Gsheets into the template directory. The usual release pipeline will then build and merge all the templates into a single component (`src/ontology/components/all_templates.owl`). The rest of the release pipeline works as usual. 

```
cd src/ontology
sh run.sh make prepare_release -B

# or, to skip mirror download
sh run.sh make MIR=false prepare_release -B

# or, to skip import re-generations altogether (including mirrors)
sh run.sh make IMP=false prepare_release -B
```

Important: If you ROBOT templates contain a new relationship, say `'develops from' some %	C`, this means that in order for the template to compile correctly, you need to first add the respective RO relationship. I usually cheat here and simply:

1) add a declaration to the edit file

```
Declaration(Class(<http://purl.obolibrary.org/obo/RO_0002202>))
```

2) Refresh the RO import:

```
sh run.sh make imports/ro_import.owl
```

This will import the new relation from RO.

# Notes for curators:

There are only three files that should be edited manually:

- `../templates/subclasses.tsv` is used to align imported ontologies with subclass axioms.
- `../templates/config.txt` is used to import external TSV files into the repo (see section 'Configuring COVOC templates')
- `covoc-edit.owl` can be edited to change or add ontology metadata (description, contributors etc) or add imports.

## Adding am import

- change `covoc-odk.yaml` to add import in the usual way.
- Run:
```
cd src/ontology
sh run.sh make update_repo
```
- update `catalog-v001.xml` to add the new import redirect, and `covoc-edit.owl` to include the import.

