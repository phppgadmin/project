#!/bin/sh
# Usage from your git repository: ./release.sh GITTAG FILEVERSION
[ $# -ne 2 ] && echo "Usage: ./release.sh GITTAG FILEVERSION" && exit 1

git tag -l ${1}

[ ${?} -gt 0 ] && echo "You should run this script from your git repository" && exit 1

git archive --prefix=phpPgAdmin-${2}/ --format=tar ${1} | tar x -C /tmp
cd /tmp/phpPgAdmin-${2}/

# remove extraneous files 
rm BUGS

# remove links to selenium tests from formal release 
gsed -i '/selenium/d' intro.php

# over the years some files have been checked in with executable mode, turn that off 
find . -name \*.php | xargs chmod a-x

# setup config file 
cp conf/config.inc.php-dist conf/config.inc.php

# build release files 
cd /tmp
tar c phpPgAdmin-${2} | bzip2 --best > phpPgAdmin-$2.tar.bz2
tar c phpPgAdmin-${2} | gzip --best > phpPgAdmin-$2.tar.gz
zip -9 -r phpPgAdmin-${2}.zip phpPgAdmin-${2}

echo "Now upload the new files ( /tmp/phpPgAdmin-$2.* to the Github release page."
