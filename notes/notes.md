# Linux / Coding notes

Double commander won't directly open (double click / open action) executable files.
<https://ghisler.ch/board/viewtopic.php?t=9073>

## collapsible markdown

<details><summary>CLICK ME</summary>
<p>

~~~python
print("hello world!")
~~~

</p>
</details>

## apt update

err 503 --> change update server (software-properties-gtk)

## Keyboard mapping

[Ctrl + Page UP / Page Down are reversed](https://unix.stackexchange.com/questions/524250/ctrl-page-up-page-down-are-reversed)

[Fix fn/function key to work as F-X as default](https://www.hashbangcode.com/article/turning-or-fn-mode-ubuntu-linux), not special action:

~~~bash
echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u -k all #kill service that keeps value from changing
reboot
~~~

Switching esc with caps lock???
`setxkbmap -option caps:swapescape`
    caps:swapescape                Swap Esc and Caps Lock
    caps:escape                    Make Caps Lock an additional Esc
    caps:escape_shifted_capslock   Make Caps Lock an additional Esc, but Shift + Caps Lock is the regular Caps Lock

## Useful locations

~~~bash
# local
/home/local/USHERBROOKE/rabj2301/Projects/epi_ml/epi_ml/python/core/data/
# helios
/home/laperlej/public/saccer3/10kb_all_none
# mp2b
/nfs3_ib/10.4.217.32/home/genomicdata/ihec_datasets/{release}/*/{assembly}/*
/nfs3_ib/10.4.219.38/jbodpool/ihec_data/share/2019-11/*/{assembly}/* #infiniband
/nfs3_ib/10.0.219.38/jbodpool/ihec_data/share/2019-11/*/{assembly}/* #ethernet
/nfs3_ib/ip29/ip29/jacques_group/local_ihec_data/
/project/6007017/jacques_group/geec_share/public_dsets & /project/6007017/jacques_group/geec_share/saccer


# mounts
/run/user/1810992820/gvfs/sftp:host=helios.calculquebec.ca,user=rabyj/home/rabyj/
/run/user/1810992820/gvfs/sftp:host=cedar.computecanada.ca,user=rabyj/home/rabyj/
/run/user/1810992820/gvfs/sftp:host=mp2b.calculquebec.ca,user=rabyj/home/rabyj/
sftp://rabyj@ip29.ccs.usherbrooke.ca/home/rabyj/rabyj # add folder on VSCode, not via local terminal like others

#force unmount
umount -f -l /mnt/myfolder
~~~

## Other tricks

Get md5sums from matrix

~~~bash
cut -f1 hg19_1kb_all_blklst_pearson.mat | tail -n +2 | sort -u | grep -v "^[[:space:]]*$" > hg19_1kb_all_blklst_pearson.md5
~~~

## VSCode

### Shortcuts

outdent: shift + tab
cursor at end of lines: shift+ctrl+alt+l
Add cursors: select text + press alt

### Notes

If right click is misbehaving (context menu dissapears if not holding right click), make sure terminal zoom is reset.

### local debug with attach

Might need to do this command if debug server unable to attach

`echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope`

See [What is the 'ptrace_scope' workaround for Wine programs and are there any risks?](https://askubuntu.com/questions/146160/what-is-the-ptrace-scope-workaround-for-wine-programs-and-are-there-any-risks)

### Debug on compute node

Remote Development on Clusters with VSCode (Sharcnet HPC) (past 53:15)

One time: make sure your public key is on the cluster. `cat ~/.ssh/id_ed25519.pub | ssh narval "cat >> ~/.ssh/authorized_keys"`
salloc a compute node, e.g. `salloc --time=2:0:0 --ntasks=1 --mem=80G --account=rrg-jacquesp-ab`
Log on that node separatly via ssh, once you know the node. This will permit to add the fingerprint in your allowed connections.

Now, you should be able to log via remote-ssh and proxy jump, e.g.

~~~text
Host vscode-narval
    HostName nl10401
    ProxyJump narval.computecanada.ca
~~~

Make sure once the vscode server is running that you are not in restricted mode.

It is better to attach a python debugger to a process rather than trying to make a launch task, since the virtual environment can be extremely finicky.

## Regex

vscode: regex to find and replace 'foo' and capture part of it: `'([\w \(\)\.]*)'`

<https://stackoverflow.com/questions/977251/regular-expressions-and-negating-a-whole-character-group>
python: To match a string which does not contain the multi-character sequence `ab`, you want to use a negative lookahead: `^(?:(?!ab).)+$`

## Python

### conda

create env
`conda env create -n envname --file environment.yml`

### install venv from requirements

~~~bash
virtualenv VENV
. VENV/bin/activate
pip list # verif, supposed to be almost empty
pip install -r requirements.txt
~~~

### Documenting code

[pdoc - best practices for GitHub pages?](https://github.com/pdoc3/pdoc/issues/55)

~~~bash
# from git root
pdoc3 --html -o docs/epi_ml/ src/python/ # --force
~~~

### pylint

When installing, make sure to check for

- pylint installed in venv, and pointed to in workspace/project settings
- pylintrc file present and pointed to
- old .vscode files are deleted
- If "total problem" number does not match what is shown in panel, remove filters

~~~bash
pylint --generate-rcfile > $HOME/.pylintrc #generate a pylint rc file with all its options present
pylint --rcfile /path/to/pylintrc path/to/file-to-lint.py #use a specific rcfil

pylint: disable=unused-argument # as a comment, disable a warning on one line
type: ignore # as a comment, to disable pylance warning
~~~

### black formatter

To turn on/off formatting for some lines, use a line `#fmt: off`, and then after `#fmt: on`.

### Problems

Getting first dict value : In Python 3 the dict.values() method returns a dictionary view object, not a list like it does in Python 2. Dictionary views have a length, can be iterated, and support membership testing, but don't support indexing.
solution : next(iter(dict.values())) --> first value

[Having options in argparse with a dash](https://stackoverflow.com/questions/12834785/having-options-in-argparse-with-a-dash)
Unfortunately, dash-to-underscore replacement doesn't work for positional arguments (not prefixed by --) like `logs-dir`
[Related issue](https://github.com/python/cpython/issues/59330)

## Bash

### - Permissions -

~~~bash
# - normal permissions -
chown user:group file # change owners
chmod 775 # rwxrwxr-x
chmod 2755 # directory IHEC_share drwxr-sr-x.
chmod 2750 # directory IHEC_share drwxr-s---.
find /path/to/directory -type d -exec chmod 750 {} \; # recursive give r+x permissions to directories # drwxr-x---
find /path/to/directory -type f -exec chmod 640 {} \; # recursive give r permission files # drw-r-----
chmod -R g+rwX . # set recursively read and write permissions on all files, and add execute permission on folders.
chmod -R u+rwX,g+rX,o= . # pretty explicit


# - ACL permissions -
# add specific permissions, recursive and "sticky"
setfacl -Rm u:USERNAME:rwX,d:u:USERNAME:rwX /folder/to/modify

# equivalent to
setfacl --recursive --modify "user:USERNAME:rwX,default:user:USERNAME:rwX" /folder/to/modify
~~~

### - General -

~~~bash
# tar commands
tar -xvzf IFT870.tar.gz # x=eXtract, v=verbose, z=gz, f=file, will untar directly in cwd
tar -cvzf file.tar.gz files_to_tar # c=compress
tar cf - no_proper_relu/ | xz -z -3 -T 8 -v - > no_proper_relu.tar.xz #tar and compress (level 3, with 8 threads)

# mv from pipe
ls spam | grep -v "bam" | xargs mv -t destination

# - find an app / upgrade an app (like code or google-chrome-stable) -
dpkg --get-selections | grep 'spam'
sudo apt-get --only-upgrade install spam

# - links -
ln -s src file #create link from src to file

# - command line navigation -
ctrl+r #search in command history
ctrl+a #place cursor to beginning of line
ctrl+e #place cursor to end of line

# - kill mount -
# kill processes keeping from unmounting
lsof | grep 'mountpoint'
kill -9 PID
# kill any processes accessing address
fuser -kim /address
# force unmount
fusermount -uz /address


# kill nautilus
nautilus -q # graceful
killall nautilus # more force (might corrupt data)
pkill -9 -f nautilus # FORCED

# - add extension to some files -
for i in $(ls | grep -Ev '\.merge'); do mv $i ${i}.merge; done

# - redirection -
command > out 2> error # different files
command > out 2>&1 # same files, universal
command &> out # same files, not always supported out of bash
command 2>&1 # redirect stderr to stdout, useful with tee

# -- find --
# list number of files in multiple directories
find . -type f | cut -d/ -f2 | sort | uniq -c

# list files with full paths in directory (give full path to find)
a_path=$(pwd -P)
find ${a_path} -mindepth 1 | grep "value.hdf5" | sort -u > a_list.list

# seek specific files
find . -type f | grep ".sh"

# Do an action on each file with result of find
find . -type f | grep ".sh" | xargs -I{} chmod a-x {}

# - Iterate over an array -
array=( one two three )
for i in "${array[@]}"; do
  echo $i
done

# - reactivate "repeat key" functionality -
xset r on

# loop through range
for i in {1..5}
do
   echo "Welcome $i times"
done

# memory management / disk usage
du -sh
ncdu
diskusage_report # for hpc

# -- rsync --
rsync -r -p rabyj@helios.calculquebec.ca:/home/laperlej/public/hg38/1mb_gene_none /scratch/rabyj/public/hg38/  #copy data from helios,  -p=preserve permissions

# Add news files from source to ".". Trailing slash important, means copy content and not parent directory.
rsync --ignore-existing -ave ssh rabyj@beluga.computecanada.ca:/lustre04/scratch/frosig/local_ihec_data/EpiAtlas-WGBS-100kb/hg38/hdf5/100kb_all_none/ .

# Following recursively syncs a folder tree and it's final csvs to a specified location
# -R = Relative
# /./ marks beginning of folder to sync
# <https://unix.stackexchange.com/questions/321219/rsync-using-part-of-a-relative-path>
rsync -aR narval:~/path/to/folder/./folder/tree/to/sync/*.csv /destination/folder
~~~

### Sed commands

~~~bash
sed 's@/home/local/USHERBROOKE/rabj2301/Projects/epi_ml/epi_ml/python/core/data/@/home/laperlej/public/saccer3/10kb_all_none/@g'
sed 's@1mb_gene_none/@/home/laperlej/public/hg38/1mb_gene_none/@g'
sed -n LINE_NUMBERp file.txt
~~~

### Grep commands

~~~bash
cat hg38.json | grep -oE '"md5sum": "[[:alnum:]]+"' #get all md5sums from json
cat hg38_metadata.md5 | grep -oE '[[:alnum:]]{32}' | head
find ~/ihec_datasets/2018-10/ -name "ce520a74fd1d56335671e6cde5408b44" | grep 'hg38'
cat 10kb_all_none_plus.list | grep -v '\.hdf5' # check for bad files/folders in list
~~~

## Job schedulers - HPC

### Moab

<https://wiki.calculquebec.ca/w/Moab/en>

~~~bash
mjobctl -c Job_ID/Job_name #kill job on node
~~~

When the job is created, a copy of the script file is made and that copy cannot be modified.
<http://docs.adaptivecomputing.com/torque/4-0-2/Content/topics/commands/qsub.htm>

### Cedar/mp2b/beluga architecture (SLURM)

<https://docs.computecanada.ca/wiki/Running_jobs>
<https://arc-ts.umich.edu/migrating-from-torque-to-slurm/>
<https://docs.computecanada.ca/wiki/Installing_software_in_your_home_directory#Installing_binary_packages>

<https://docs.computecanada.ca/wiki/Béluga>
<https://docs.computecanada.ca/wiki/Getting_started/fr>
<https://docs.computecanada.ca/wiki/Globus/fr>

#### Slurm job scheduler commands

~~~bash
# useful
squeueme # my queued jobs
seff JOBID # job info summary
scancel JOBID # kill/cancel job
scancel -u rabyj # kill all my jobs
salloc --account=def-jacquesp # log on a compute node
diskusage_report

# get IDs from squeue
sqme > temp_sqme.txt
cat temp_sqme.txt | grep 'chr' | tr -s ' ' | cut -d ' ' -f2,5 | sort -V -k2 > temp_jobID.txt
cat temp_jobID.txt | grep "assay" > assay_jobID.txt
cat temp_jobID.txt | grep "cell" > cell_type_jobID.txt
~~~

#### sbatch file (.sh)

~~~bash
#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --account=def-jacquesp
#SBATCH --job-name=a_job_name
#SBATCH --output=%x-%j.out
#SBATCH --mem=32G
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH --mail-user=joanny.raby@usherbrooke.ca
#SBATCH --mail-type=END

#Variables
${SLURM_JOB_ID} (%j)
${SLURM_JOB_NAME} (%x)
~~~

<https://stackoverflow.com/questions/65677339/how-to-retrieve-the-content-of-slurm-script>
Recuperate launch script: `scontrol write batch_script <job_id> <optional_filename>`

#### Collect resources via seff

~~~bash
ls *.out | grep -oE '[0-9]{7}' | xargs -n1 seff | grep 'Wall' | grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}'
ls *.out | grep -oE '[0-9]{7}' | xargs -n1 seff | grep 'Memory Utilized' | grep -oE '[0-9]{1,2}\.[0-9]{1,2} .B'
ls *.out | grep -oE '[0-9]{7}' | xargs -n1 seff | grep 'CPU Efficiency:' | grep -oE '[0-9]{1,2}\.[0-9]{1,2}\%'
~~~
