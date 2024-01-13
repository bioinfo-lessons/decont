#### **Some details of my work**

1. I have created a file for the contaminants url just to be able to change the url in case of it changes or we want to download another file.
2. I have also changed the names of the urls files and I added extensions to this files. I know this don't change anything of the program.
3. In the `cleanup.sh` script.
    * I firstly create a if loop to check if the input are 4 or none. With this conditions the code have to do the same: delete all created files except the urls.txt in the data folder and the `contamintans_url.txt` in the res folder.
    * Then if the conditions of the if loop are not achieve, I save all of the inputs in a variable and for each of the names that could be as input, if them are the same in the inputs list, then we have to delete all files of the folder except, as in the case of all fles have to be deleted, we have to keep `data/urls.txt` and `res/contaminants_url.txt`.
4. In the scripts folder, there are two scripts, the differences of those two scrips is that one is with the download loop (`pipeline.sh`) and the second one is with one-liner `wget` (`pipeline_2.sh`). This is due to the scipt of the loops works correctly, and I created the second one to try to do the one-liner `wget`. Once it work I upload both.
5. The `md5script.sh` compares both md5 of the local file and the md5 of the remote one. I was not able to do this part without downloading the md5 of the URL. So I download the md5 of the URL and compare that one with the downloaded file one.



# Decontamination of small-RNA sequencing samples from mouse

## Introduction

In this project, you will be "decontaminating" some small-RNA samples from a couple
of mouse strains (black6 and spretus). "Decontaminating" means removing sequences
we are not interested in from our samples before processing them.

In this case the sequence we will be removed are not really contaminants, but rather
RNA species that are very abundant and that we have no interest in analysing.

To decontaminate a sample, you simply align all your reads to the contaminants list,
as if it were a genome, and *keep the reads that do* **not** *align*. These reads that do
not align are the decontaminated reads, and you will use them for your downstream analysis.

The same procedure could be used to remove any type of contaminants, just by
changing the contents of the contaminants database fasta.

The sample names you will be working with are "C57BL_6NJ" and "SPRET_EiJ". You have multiple
files for each because one sequencing run was not enough, so you had to re-sequence your samples,
resulting in technical replicates. This means that you will be merging all files for the same sample
to increase your sequencing depth.

> IMPORTANT: your pipeline should be able to analyse an arbitrary number of samples located in
the `data` directory

## Setting up your environment

### Conda

You should create a new, empty conda environment. Make sure you have set up 
Bioconda to be able to install the necessary packages. [See this link for details
on setting up conda and bioconda](http://bioconda.github.io/).

### Git repository

Your working directory will be under git control. You will first fork (copy) this repository
to your GitHub account, and then work on this new copy using it as your remote.

#### Forking this repository

You should start by forking this repository. A git **fork** creates a copy
of the repository *on your own GitHub account*. This copy will become the remote
repository where you will eventually save your work.

You can find the fork button on the top right of the repository webpage on GitHub.

Once you fork the project, you will have a copy of the repository on a new URL:

`https://github.com/<your_username>/decont`

#### Adding your instructor as a collaborator

You should now add your instructor as a collaborator in your copy of the repository,
so that she/he can interact with you during the development. You can do this by going
to "Settings > Collaborators and teams > Add people" and adding your instructor's username.

#### Getting help

You can now ask for help from your instructor by creating a new issue in the GitHub
repository adding a relevant title and description, **and assigning the issue to your instructor**.

You can assign the issue by clicking on the "Assignees" title on the top right.

> Make sure to check that your instructor appears on the list of possible assignees.

#### Cloning your fork and starting work

You should now **clone** your new repository to obtain a local copy on your machine.

You can then start working on your local copy of the repository.

> Remember to commit often. Don't go crazy about it, but do generate a history of your work.

### Organisation of your files

The repository already contains a folder structure to help you organise your files.
It also contains the list of data files to download, and an incomplete main script
with a draft workflow that you should complete.

> You may need to create extra directories to store some files.

## Your tasks

Your job is to develop a pipeline to decontaminate the downloaded samples, leaving them 
ready for further analysis.

When complete, your pipeline should be able to automatically do the following (list not necessarily in order):

> Remember to activate your conda environment and to always check that you are in the root of your working directory.

- Download the sequencing data files
    - The list of urls is available in `data/urls`
- Download the contaminants database
    - `https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz`
- Remove all sequences corresponding to small nuclear RNAs from the contaminants
  list before using it
    - Make sure you don't mix "small nuclear" and "small nucleolar"
- Merge the fastqs from the same sample into a single file
- Remove the adapters from the data (cutadapt in conda)
- Index the contaminants database (star in conda, as if it were a genome)
- Align the adapter-free reads to the contaminants genome, telling star to output the non-aligned reads in FastQ format (also with star)
- Create a log file with information on trimming and alignment results

> Start by looking a the "scripts/pipeline.sh" script, which is the entry point
> for the pipeline execution.

> The scripts contain comments to guide you in the tasks you need to perform.
> Look for the *#TODO* comments, which indicate parts that need to be modified.

## Adding commits to the repository

You are encouraged to make atomic commits to the repository. This means that
each commit should make only one logical change to your code. This could be
fixing a single bug, adding a single feature, rearranging a section of code,
and so on.

If you're unsure, it's better to commit more frequently rather than less.
Too many commits can always be squashed together later if necessary, but
it is much more difficult to separate changes if they've been bundled into
a single commit.

If you'd like to read more about atomic commits see [here](https://www.aleksandrhovhannisyan.com/blog/atomic-git-commits/).

## Once you are done

Once you are done, you should first export a file with your conda environment information.

```shell
conda env export --from-history > envs/decont.yaml
```

You should **add** the environment file to the staging area, **commit** it to the local repository,
and **push** your changes to the remote repository.

## Hints

### The `basename` command

Basename allows you to obtain the last section of a path, and optionally remove a suffix from it.
> This should prove very useful to extract the sample IDs from paths.

```shell
# keep the filename only from a path
$ basename out/data/mysample.tar.gz
mysample.tar.gz

# keep the filename only from a path, and remove the extension
$ basename http://mydomain.com/out/data/mysample.tar.gz .tar.gz
mysample

# keep the last directory from a path
$ basename out/star/logs
logs
```

### Merging compressed text files

You can merge compressed text files by using cat:

```shell
cat file1.tar.gz file2.tar.gz > merged.tar.gz
```

### Comparing strings in the `if` control statement

You can compare a variable and a strings inside an if statement by doing `if [ "$myvar" == "hello" ]`

### Setting the output directory for `wget`

The `-P` argument allows you to give wget a directory where to store the downloaded files.

### Creating directories

You can use the `-p` argument of `mkdir` to create a directory if
it doesn't exist, and do nothing if it does. This is useful so that there
are no errors when running a script many times.

### Filtering sequence files

You can choose to write your own code to do the filtering, or use something like
the `seqkit` package available in bioconda.

### Final state of your working directory

When you are done, your working directory should look something like this:

> This is just to guide you, it doesn't need to be the exact same.

```shell
.
├── data
│   ├── C57BL_6NJ-12.5dpp.1.1s_sRNA.fastq.gz
│   ├── C57BL_6NJ-12.5dpp.1.2s_sRNA.fastq.gz
│   ├── SPRET_EiJ-12.5dpp.1.1s_sRNA.fastq.gz
│   ├── SPRET_EiJ-12.5dpp.1.2s_sRNA.fastq.gz
│   └── urls
├── log
│   ├── cutadapt
│   │   ├── C57BL_6NJ.log
│   │   └── SPRET_EiJ.log
│   └── pipeline.log
├── Log.out
├── out
│   ├── merged
│   │   ├── C57BL_6NJ.fastq.gz
│   │   └── SPRET_EiJ.fastq.gz
│   ├── star
│   │   ├── C57BL_6NJ
│   │   │   ├── Aligned.out.sam
│   │   │   ├── Log.final.out
│   │   │   ├── Log.out
│   │   │   ├── Log.progress.out
│   │   │   ├── SJ.out.tab
│   │   │   └── Unmapped.out.mate1
│   │   └── SPRET_EiJ
│   │       ├── Aligned.out.sam
│   │       ├── Log.final.out
│   │       ├── Log.out
│   │       ├── Log.progress.out
│   │       ├── SJ.out.tab
│   │       └── Unmapped.out.mate1
│   └── trimmed
│       ├── C57BL_6NJ.trimmed.fastq.gz
│       └── SPRET_EiJ.trimmed.fastq.gz
├── res
│   ├── contaminants.fasta
│   ├── contaminants.fasta.gz
│   └── contaminants_idx
│       ├── chrLength.txt
│       ├── chrNameLength.txt
│       ├── chrName.txt
│       ├── chrStart.txt
│       ├── Genome
│       ├── genomeParameters.txt
│       ├── SA
│       └── SAindex
└── scripts
    ├── download.sh
    ├── index.sh
    ├── merge_fastqs.sh
    └── pipeline.sh
```

## Bonus exercises

These are not required for the completion of the practical, but you can complete them for extra points.

- Replace the loop that downloads the sample data files with a wget one-liner.
- Check if the output already exists before running a command. If it exists, display a message, skip the operation,
and continue.
- Add md5 checks to the downloaded files (you can find the md5 hashes in the same URLs by
  adding the ".md5" extension). Full points for not downloading the md5 files.
- Add a "cleanup.sh" script that removes created files. It should take zero or
  more of the following arguments: "data", "resources", "output", "logs". If no
  arguments are passed then it should remove everything.

