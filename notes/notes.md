# Linux / Coding notes

## Firefox

### Profile problems

If Zotero is opening URLs in a different Firefox window (profile),
go in about:profiles, and find the one to delete. To change default profile manually and
make sure you've deleted irrelevant ones, check out `/home/local/USHERBROOKE/rabj2301/.mozilla/firefox/profiles.ini`

You also need to add `StartupWMClass=firefox` in the .desktop file make sure all instances open under
the same dash icon.

The .desktop file used needs to be the one created by firefox when setting firefox browser as default.

### Dark Reader Extension

Possible patterns for values are google.com, mail.google.com, google.*, google.com/maps etc.
Regular expressions are supported. They should start and end with `/`, like `/www\.google\..*/`.
In a regular expression, `/` needs to be escaped, e.g. `/docs\.google\.com\/presentation.*/`
Source: <https://darkreader.org/help/en/>

### Google sheets

Creating custom formulas:

- drop-down filter view: Start row number at the first data row (usually 2)
- conditionnal formatting: Start at the first row

Example: `=NOT(REGEXMATCH(CLEAN($J1), "C-A.*_no_cell_line\.tsv|recount3.*_no_cell_line\.tsv"))`

## Slack

Read all messages in a workspace: shift+esc
Hide/Show worspaces: Ctrl + Shift + S
Reload Slack: Ctrl + Shift + R
Slack tweaks (remove new sidebar): <https://gist.github.com/Kenny-MWI/6b1a88ad38b5ffef347527a82becf054>

## Linux

### .Desktop files for launcher access

Stored in

- `~/.local/share/applications/`
- `/usr/share/applications`

To have windows started under the same icon, add `StartupWMClass=xxxx` in the .desktop file.
The value can be found with `xprop WM_CLASS` and clicking on the window.

To rebuild mimeinfo.cache (file associations):

```bash
update-desktop-database path/to/desktop/files/
```

### Journals/Logs

```bash
journalctl --disk-usage # check size used by journals
journalctl --vacuum-size=1G # remove journals until under that size
journalctl --vacuum-time=1s --unit=slack.desktop #remove specific entries
sudo systemctl restart systemd-journald.service # force journal rotation
nano /etc/systemd/journald.conf # SystemMaxUse=1G for max 1G used total
```

### Filesystem handling

```bash
sudo tune2fs -c 5 /dev/sda1 # check filesystem state each 5 startup/mounts
sudo tune2fs -e remount-ro /dev/sda1 # if kernel error, remount drive as read-only, prevents corruption spreading.
```

### Music format conversion

```bash
# flac to opus, excellent for size, very probably transparent for my ears at this bitrate
for path in */*.flac; do ffmpeg -i "$path" -vn -acodec libopus -ab 96k "${path%.flac}.opus"; done
```

### Gnome Window Management

Hold down the Super key (option) and use arrows

Window/Maximise: ↓, ↑
Put left/right of screen: ←, →

### Memory/swap handling

reset swap: `sudo swapoff -a; sudo swapon -a`

### Gnome / Ubuntu specific extensions

Use an [extension](https://extensions.gnome.org/) manager to modify some things on Ubuntu (gnome),
e.g. adding things on upper bar (ram usage, different clock formatting, and more)
There is browser connector or a local version on flatpak
`flatpak install flathub com.mattjakeman.ExtensionManager`
clock override in GUI settings: `%F %H:%M`

### apt update

err 503 --> change update server (software-properties-gtk)

### Keyboard mapping

#### Page Up/Down

[Ctrl + Page UP / Page Down are reversed](https://unix.stackexchange.com/questions/524250/ctrl-page-up-page-down-are-reversed)

#### fn/fonction key

[Fix fn/function key to work as F-X as default](https://www.hashbangcode.com/article/turning-or-fn-mode-ubuntu-linux), not special action:

```bash
# Change fn/function key mode
echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u -k all #kill service that keeps value from changing
reboot
```

#### Switching escape/caps and co

Use keyd

#### Volume increment

Change default system volume increment (works for fn vol up/down keys)

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-step 1
```

#### Caps lock out of sync

Use gnome tweaks to enable "Both shifts together enable Caps Lock; one Shift key disables it" in keyboard layout compatibility options.  
See: [Caps Lock toggle reversed and malfunctioning](https://discussion.fedoraproject.org/t/fedora-39-caps-lock-toggle-reversed-and-malfunctioning/95458/6)

### File manager

#### Change file association

Open-with -> change default association and save (in doublecmd, restart app)
Manually: change ~/.config/mimeapps.list

To check the mime type of a file: `file --mime-type filename`

#### Double commander

- Double commander won't directly open (double click / open action) executable files. <https://ghisler.ch/board/viewtopic.php?t=9073>
- Sometimes the history gets corrupted and program fails on open (EAccessViolation:). Delete it: `rm ~/.config/doublecmd/history.xml`

#### KDE

Change file picker to KDE overall, makes Ubuntu slower at login.
`export GTK_USE_PORTAL=1` in `/etc/profile`

## Markdown

### Collapsible/foldable markdown

<details><summary>CLICK ME</summary>
<p>

```python
print("hello world!")
```

</p>
</details>

## Useful paths/locations

```bash
# helios
/home/laperlej/public/saccer3/10kb_all_none
# mp2b
/nfs3_ib/10.4.217.32/home/genomicdata/ihec_datasets/{release}/*/{assembly}/*
/nfs3_ib/10.4.219.38/jbodpool/ihec_data/share/2019-11/*/{assembly}/* #infiniband
/nfs3_ib/10.0.219.38/jbodpool/ihec_data/share/2019-11/*/{assembly}/* #ethernet
/nfs3_ib/ip29/ip29/jacques_group/local_ihec_data/
/project/6007017/jacques_group/geec_share/public_dsets & /project/6007017/jacques_group/geec_share/saccer
```

## VSCode

### Shortcuts

outdent: shift + tab
cursor at end of lines: shift+ctrl+alt+l
Add cursors: select text + press alt

### Rename with regex

rename md5s

(\w{32}) # capture group, refer with $1
/lustre07/scratch/rabyj/local_ihec_data/epiatlas/hg38/hdf5/EpiAtlas_dfreeze_100kb/$1_100kb_all_none_value.hdf5

### Notes

If right click is misbehaving (context menu dissapears if not holding right click), make sure terminal zoom is reset.

### Local debug with attach

Might need to do this command if debug server unable to attach

`echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope`

See [What is the 'ptrace_scope' workaround for Wine programs and are there any risks?](https://askubuntu.com/questions/146160/what-is-the-ptrace-scope-workaround-for-wine-programs-and-are-there-any-risks)

### Debug on compute node

Remote Development on Clusters with VSCode (Sharcnet HPC) (past 53:15)

One time: make sure your public key is on the cluster. `cat ~/.ssh/id_ed25519.pub | ssh narval "cat >> ~/.ssh/authorized_keys"`
salloc a compute node, e.g. `salloc --time=2:0:0 --ntasks=1 --mem=80G --account=rrg-jacquesp-ab`
Log on that node separatly via ssh, once you know the node. This will permit to add the fingerprint in your allowed connections.

Now, you should be able to log via remote-ssh and proxy jump, e.g.

```text
Host vscode-narval
    HostName nl10401
    ProxyJump narval.computecanada.ca
```

Make sure once the vscode server is running that you are not in restricted mode.

It is better to attach a python debugger to a process rather than trying to make a launch task, since the virtual environment can be extremely finicky.

## Regex

vscode: regex to find and replace 'foo' and capture part of it: `'([\w \(\)\.]*)'`

<https://stackoverflow.com/questions/977251/regular-expressions-and-negating-a-whole-character-group>
python: To match a string which does not contain the multi-character sequence `ab`, you want to use a negative lookahead: `^(?:(?!ab).)+$`

## Python

### pip

See available package versions: `pip index versions packageName`

### Imports

[Sibling package imports](https://stackoverflow.com/questions/6323860/sibling-package-imports)
[Relative imports in Python 3](https://stackoverflow.com/questions/16981921/relative-imports-in-python-3)
[Relative imports for the billionth time](https://stackoverflow.com/questions/14132789/relative-imports-for-the-billionth-time)

### conda

create env
`conda env create -n envname --file environment.yml`

### install venv from requirements

```bash
virtualenv VENV
. VENV/bin/activate
pip list # verif, supposed to be almost empty
pip install -r requirements.txt
```

### Documenting code

[pdoc - best practices for GitHub pages?](https://github.com/pdoc3/pdoc/issues/55)

```bash
# from git root
pdoc3 --html -o docs/epiclass/ src/python/ # --force
```

### pylint

When installing, make sure to check for

- pylint installed in venv, and pointed to in workspace/project settings
- pylintrc file present and pointed to, or a toml file with pylint section
- old .vscode files are deleted
- If "total problem" number does not match what is shown in panel, remove filters

```bash
pylint --generate-rcfile > $HOME/.pylintrc #generate a pylint rc file with all its options present
pylint --rcfile /path/to/pylintrc path/to/file-to-lint.py #use a specific rcfil

pylint: disable=unused-argument # as a comment, disable a warning on one line
type: ignore # as a comment, to disable pylance warning
```

### black formatter

To turn on/off formatting for some lines, use a line `#fmt: off`, and then after `#fmt: on`.

### pytest

The `pytest -lvs` command is a combination of multiple options used with pytest. Here's the breakdown of each option:

`-l` or `--showlocals`: This option displays local variables in tracebacks for test failures. It provides additional context by showing the values of local variables at the time of the failure.

`-v` or `--verbose`: This option enables verbose mode and provides more detailed information about the tests being executed. It displays the names of the tests, along with the test outcomes (pass or fail), and any captured output.

`-s` or `--capture=no`: This option disables the capture of stdout and stderr during test execution. It allows the output from print statements and other standard output streams to be displayed in the console.

Disable warnings in config:
[action:message:category:module:line](https://docs.python.org/3/library/warnings.html#warning-filter)

### Problems

Getting first dict value : In Python 3 the dict.values() method returns a dictionary view object, not a list like it does in Python 2. Dictionary views have a length, can be iterated, and support membership testing, but don't support indexing.
solution : next(iter(dict.values())) --> first value

Unfortunately, dash-to-underscore replacement doesn't work for positional arguments (not prefixed by --) like `logs-dir`
[Having options in argparse with a dash](https://stackoverflow.com/questions/12834785/having-options-in-argparse-with-a-dash)
[Related issue](https://github.com/python/cpython/issues/59330)

## Bash

### - Conditional expressions -

Source: <https://stackoverflow.com/questions/13617843/unary-operator-expected-error-in-bash-if-condition>

If you know you're always going to use Bash, it's much easier to always use the double bracket conditional compound command `[[ ... ]]`, instead of the POSIX-compatible single bracket version `[ ... ]`. Inside a `[[ ... ]]` compound, word-splitting and pathname expansion are not applied to words, so you can rely on

`if [[ $aug1 == "and" ]];`

to compare the value of `$aug1` with the string `and`.

If you use `[ ... ]`, you always need to remember to double quote variables like this:

`if [ "$aug1" = "and" ];`

If you don't quote the variable expansion and the variable is undefined or empty, it vanishes from the scene of the crime, leaving only

`if [ = "and" ];`

which is not a valid syntax. (It would also fail with a different error message if `$aug1` included white space or shell metacharacters.)

The modern `[[` operator has lots of other nice features, including regular expression matching.

### - Permissions -

```bash
# - normal permissions -
chown user:group file # change owners
chmod 775 # rwxrwxr-x
chmod 2755 # directory IHEC_share drwxr-sr-x.
chmod 2750 # directory IHEC_share drwxr-s---.
find /path/to/directory -type d -exec chmod 750 {} \; # recursive give r+x permissions to directories # drwxr-x---
find /path/to/directory -type f -exec chmod 640 {} \; # recursive give r permission files # -rw-r-----
chmod -R g+rwX . # set recursively read and write permissions on all files, and add execute permission on folders.
chmod -R u+rwX,g+rX,o= . # pretty explicit


# - ACL permissions -
# add specific permissions, recursive and "sticky"
setfacl -Rm u:USERNAME:rwX,d:u:USERNAME:rwX /folder/to/modify
getfacl folder # see acl permissions

# equivalent to
setfacl --recursive --modify "user:USERNAME:rwX,default:user:USERNAME:rwX" /folder/to/modify
```

### - General -

```bash
# Dictory where .sh file is located. Current folder path. Current dir path. Script dir path.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


# recursive touch
find folder -type f -exec touch -ac {} + # a=access time, c=do not create file

# execute series of commands via nohup
nohup sh -c 'XZ_DEFAULTS="-6e -T2" && tar --xz -cf 2023-01-epiatlas-freeze.tar.xz 2023-01-epiatlas-freeze/' > /dev/null 2>&1 &

# put commands to background and safe for closing terminal, nohup like
ctrl+z
bg
disown -h # jobs will ignore hangup signal, but stay in the job table

# tar commands
tar -cf folder_name.tar folder_to_tar # c=create, create tar without compressing
tar -xvzf file.tar.gz # x=eXtract, v=verbose, z=gz, f=file, will untar directly in cwd
tar -xf file.tar.extension # recognizes many compression extensions
tar -cvzf file.tar.gz files_to_tar # create (c) + compress to gz (z)
tar cf - no_proper_relu/ | xz -z -3 -T 8 -v - > no_proper_relu.tar.xz #tar and compress (level 3, with 8 threads)
tar -tvf file.tar # list files
tar -xf file.tar path/to/file/in/tar # extract a specific file
tar -xzf images.tar.gz --transform='s/.*\///' # flatten structure during extraction
tar -xf file.tar -T file_list.txt # extract a list of files. paths need to match index.
export XZ_DEFAULTS="-6e -T2" #2 cores, level 6 extreme

# mv from pipe
ls spam | grep -v "bam" | xargs mv -t destination

# - find an app / upgrade an app (like code or google-chrome-stable) -
dpkg --get-selections | grep 'spam'
sudo apt-get --only-upgrade install spam

# - links -
ln -s src new_link_file #create a soft link from src to link
find . -type f -name '*.hdf5' -printf '%n %p\n' | grep -v "1 ." | grep -v "rank_files" > all_hardlinked_hdf5_WIP.list #finding hardlinked files

# - command line navigation -
ctrl+r #search in command history
ctrl+a #place cursor to beginning of line
ctrl+e #place cursor to end of line

# - reactivate "repeat key" functionality -
xset r on

# - kill mount / unmount-
# kill processes keeping from unmounting
lsof | grep 'mountpoint'
kill -9 PID
# kill any processes accessing address
fuser -kim /address
# lazy unmount
fusermount -uz /address # (-u=unmount, -z=lazy)
# force unmount
umount -f -l /mnt/myfolder

# create a mount point, you can alias it
sshfs -o follow_symlinks user@remote:/mount/point /path/to/local/folder

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
command 2>&1 >/dev/null | grep 'something' #piping the error to a tool like grep:The first operation is the 2>&1, which means 'connect stderr to the file descriptor that stdout is currently going to'. The second operation is 'change stdout so it goes to /dev/null', leaving stderr going to the original stdout, the pipe.

# -- tree --
tree -L [number] # depth of tree
tree -D # print date (day)
tree --timefmt "%F %T" . #(iso day + time)

# -- find --
# list/count number of files in multiple directories
find . -type f | cut -d/ -f2 | sort | uniq -c

# list files with full paths in directory (give full path to find)
a_path=$(pwd -P)
find ${a_path} -mindepth 1 | grep "value.hdf5" | sort -u > a_list.list

# list non directory on current level
find . -maxdepth 1 -type f

# seek specific files
find . -type f | grep ".sh"

# Do an action on each file with result of find
find . -type f | grep ".sh" | xargs -I{} chmod a-x {}

# Specific formatting for printf portion
find . -type f -printf '%s %p\n' # size + filepath
# %c is access time, %b is birth/creation time, %t is modification time
https://man7.org/linux/man-pages/man1/find.1.html

# List number of files in each folder
find . -type f | cut -d/ -f2 | sort | uniq -c

# List md5s from hdf5 (epigeec file format)
find . -type f -name "*.hdf5" | cut -d_ -f1 | cut -d/ -f2 | sort > ../list.md5

# Exclude files from find
find . -type f -not -path "./specific/directory/to/ignore/*"

# - Iterate over an array -
array=( one two three )
for i in "${array[@]}"; do
  echo $i
done

# loop through range
for i in {1..5}
do
   echo "Welcome $i times"
done

# memory management / disk usage
df -H # total storage info
du -sh
ncdu
diskusage_report # for hpc

# -- rsync --
rsync -ra rabyj@helios.calculquebec.ca:/home/laperlej/public/hg38/1mb_gene_none /scratch/rabyj/public/hg38/  #copy data from helios

rsync --progress -va spam bam # show progress bar and file names
rsync --info=progress2 -va spam bam # show alternative progress information: how many files have been found, and how many are transfered

rsync --dry-run -va spam bam # see what would be copied

# Add news files from source to ".". Trailing slash important, means copy content and not parent directory.
rsync --ignore-existing -ave ssh rabyj@beluga.computecanada.ca:/lustre04/scratch/frosig/local_ihec_data/EpiAtlas-WGBS-100kb/hg38/hdf5/100kb_all_none/ .

# Following recursively syncs a folder tree and it's final csvs to a specified location
# -R = Relative
# /./ marks beginning of folder to sync
# <https://unix.stackexchange.com/questions/321219/rsync-using-part-of-a-relative-path>
rsync -aR narval:~/path/to/folder/./folder/tree/to/sync/*.csv /destination/folder

# mirror directory structure (no files)
rsync -a --include='*/' --exclude='*' source/ destination/

# Copy list of files from a list of absolute paths (without first root /) to current folder
# sort list beforehand
# https://unix.stackexchange.com/questions/174674/rsync-a-list-of-directories-with-absolute-path-in-text-file
# https://stackoverflow.com/questions/16647476/how-to-rsync-only-a-specific-list-of-files/30176688#30176688
rsync -a --no-dirs --no-relative --files-from=FILE.list narval:/ .

# find file + rsync with dir structure preserved
# the directory structure starting from the directories that match split* will be preserved in the destination directory.
find split* -maxdepth 2 -type f -name '*prediction.csv' -print0 | rsync -av --files-from=- --from0 ./ $HOME/Projects/epiclass/output/paper/data/harmonized_sample_ontology_intermediate/all_splits/harmonized_sample_ontology_intermediate_1l_3000n/10fold-dfreeze-2/

# rync list of files while dir keeping structure
# The filenames that are read from the FILE are all relative to the source dir
# any leading slashes are removed and no ".." references are allowed to go higher than the source dir. 
rsync -a --files-from=/tmp/foo /usr remote:/backup

# parallel rsync using xargs, you could also use GNU parallel
# This will run 5 rsync in parallel, each run on one folder/file found by ls
ls -1 /source/dir | xargs -I {} -P 5 -n 1 rsync -avh /source/dir/{} /destination/dir/

# -- other --

# show true command, not alias
type command
\command # use unaliased command

# rename (perl syntax, sed syntax)
rename 's/\s+/_/g' * # replace spaces with underscores
# massive rename: remove part of name, rename -n for dry-run
find . -type f | grep "part-to-remove" | xargs -I{} rename 's/part-to-remove//g' {}

# comparing/diffing files, -1 and -2 remove lines unique to file 1/2, -3 removes common lines
comm -23 <(sort file1) <(sort file2) # set(file1) - set(file2), i.e lines unique to file1
comm -12 <(sort file1) <(sort file2) # set(file1) & set(file2), i.e. no unique lines

# script location/folder/directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
```

### dar - disk archiver

dar archives are of the format `archive-name.i.dar` where `i` is the slice number (starts at 1).
The slice number is not specified during operations, dar figures it out itself. Only the base name is needed.

More info: <http://dar.linux.free.fr/doc/man/dar.html>

#### Creation

Example of correct usage (`-c` for "create", `-g` for "go-into/get"):

```bash
ml StdEnv/2023
dar --multi-thread 2 -c "${archive_name}" -g "${input_folder}" -g "${input_file}"
# or general backup of a folder
dar --multi-thread 2 -c "${archive_name}" -R "${folder}"
```

Note that:

- dar does not accept Unix wild masks after `-g`.
- `-R` actually specifies the filesystem root to use (R for root and not recursive), and can be used with the restore operation too.
- `--multi-thread` can be written as `-G` too.

Always make an separate index and test integrity after creating an archive:

```bash
dar -l "${archive_name}" > ${archive_name}.dar.index # list all
dar -t "${archive_name}" > ${archive_name}.dar.test # test integrity
```

You can control the compression type using `-z` flag:

```bash
dar --multi-thread 2 -z lz4 -c "${archive_name}" -g "${input_folder}"
```

If `-z` is not specified, no compression is performed, but if `-z` is specified without algorithm gzip will be assumed.

Complex example:

```bash
nice dar -Q --multi-thread 10 --compression=xz --slice 20G -c archive_name -u 'lustre*' -g folder1/ &> dar_archive_name.log &
```

#### Extraction

Then, to extract (`-x`) a single file into a subdirectory `restore`, use the base name and the file path:

```bash
dar -R restore/ -O -w -v -x ${archive_name} -g directory/filename
```

The flag `-O` will tell dar to ignore file ownership. The flag `-w` will disable a warning if `restore/directory` already exists.

To extract an entire directory, type:

```bash
dar -R restore/ -O -w -v -x ${archive_name} -g ${directory_or_filename}
```

Complex example:

```bash
nohup nice dar -Q --multi-thread 5 -O -w -x archive_name &> dar_restore_archive_name.log &
```

This will overwrite existing files without asking, because of the `-w` flag. (don't warn)

#### Pitfalls

##### Dar version

Be careful to use the same DAR version to extract as was used to compress, otherwise you might get errors.

In this example, HPC `StdEnv/2020` was loaded instead of `StdEnv/2023`.

```text
[rabyj@narval3 bg]$ dar -x cpg_topvar_200bp_10kb_coord -O
Final memory cleanup...
FATAL error, aborting operation
Not enough data to initialize storage field
```

##### Extended attributes and Lustre

On HPCs, the extended attributes can also cause problem, see this note about the Lustre filesystem:
[Alliance dar doc](https://docs.alliancecan.ca/wiki/Dar#A_note_about_the_Lustre_filesystem)

When extracting to the compute node scratch/tmpdir, the extended attributes might also cause problems, for example:

- `system.posix_acl_access`
- `lustre.*` attributes in general

To ignore extended attributes, use the `-u mask` flag when creating or extracting dar archives.
The mask can include wildcards.

- Use `-u 'lustre*'` for Lustre filesystems.
- Use `-u '*'` to ignore all extended attributes.

##### Interactive vs script usage

See the `-Q` flag description in the manual for details, but in summary, when using dar in scripts but launching from terminal (not via cron or batch job), dar might think it's in interactive mode and ask for user input, which will block the script. Use `-Q` to force non-interactive mode, e.g.

```bash
dar -Q ... 1> dar.out 2> dar.err &
```

This is the only way to make sure dar can run in background without blocking.

### Sed commands

```bash
sed -n LINE_NUMBERp file.txt # disable automatic printing
sed -i 's/STRING_TO_REPLACE/STRING_TO_REPLACE_WITH/g' filename # inplace
sed -i '8i This is Line 8' filename # insert text at line number (inplace)
```

### Grep commands

```bash
# Get md5sums from different files
cat hg38.json | grep -oE '"md5sum": "[[:alnum:]]{32}"' # json
cat hg38_metadata.md5 | grep -oE '[[:alnum:]]{32}' | head # md5
cut -f1 hg19_1kb_all_blklst_pearson.mat | tail -n +2 | sort -u | grep -v "^[[:space:]]*$" > hg19_1kb_all_blklst_pearson.md5 # matrix

cat 10kb_all_none_plus.list | grep -v '\.hdf5' # check for bad files/folders in list

# scratch delete/purge list without empty paths
grep -Ev '^"","' /scratch/to_delete/rabyj > ~/to_delete_rabyj.csv

# Grep with a list of patterns
grep -f pattern_list.ext target.ext

# Grep using a literal string, don't need to escape anything. Faster than normal grep.
grep -F "string" target.ext 
grep -F -f string_list.ext target.ext # grep a list of literal strings.
```

## Job schedulers - HPC

### Moab

<https://wiki.calculquebec.ca/w/Moab/en>

```bash
mjobctl -c Job_ID/Job_name #kill job on node
```

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

```bash
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
```

#### sbatch file (.sh)

```bash
#!/bin/bash
#SBATCH --time=01:00:00 # hh:mm:ss
#SBATCH --account=def-jacquesp # project/account name
#SBATCH --job-name=a_job_name # name of job
#SBATCH --output=%x-job%j.out # output file name (%x=job name, %j=job id)
#SBATCH --mem=32G # memory per node
#SBATCH --cpus-per-task=1 # number of cpu cores per task
#SBATCH --gres=gpu:1 # number of gpus per node, if needed. Ususally remove this line.
#SBATCH --mail-user=prenom.nom@usherbrooke.ca
#SBATCH --mail-type=END
#SBATCH --dependency=afterok:<JOBID> # job dependency, optional

#Useful variables
echo ${SLURM_JOB_ID} # equivalent to '%j' in SBATCH header
echo ${SLURM_JOB_NAME} # equivalent to '%x' in SBATCH header
echo $SLURM_CPUS_PER_TASK
echo $SLURM_TMPDIR # path to temporary folder on compute node, very fast for IO
```

<https://stackoverflow.com/questions/65677339/how-to-retrieve-the-content-of-slurm-script>
Recuperate launch script: `scontrol write batch_script <job_id> <optional_filename>`

#### Collect resources via seff

```bash
ls *.out | grep -oE '[0-9]{7}' | xargs -n1 seff | grep 'Wall' | grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}'
ls *.out | grep -oE '[0-9]{7}' | xargs -n1 seff | grep 'Memory Utilized' | grep -oE '[0-9]{1,2}\.[0-9]{1,2} .B'
ls *.out | grep -oE '[0-9]{7}' | xargs -n1 seff | grep 'CPU Efficiency:' | grep -oE '[0-9]{1,2}\.[0-9]{1,2}\%'
```

## Machine Learning

### pytorch - lazy loading of large datasets

It would seem LRU caching is useless here, as there no repeated data in a single epoch, and the whole approach presumes the entire dataset does not fit in memory.
See: [Pytorch comment](https://github.com/pytorch/pytorch/issues/43012#issuecomment-688786155)

Quote: LRU caching might not be useful at all...AFAIK a lot training tasks require sampling without replacement, so there is little locality for the LRU cache algorithm to exploit.

In other words, for multi-epoch training, caching part of the dataset is no better than caching nothing.
