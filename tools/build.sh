#!/bin/sh

PROJECT="$1"
MONOREPODIR=$PWD
BASEDIR=$PWD/projects/$PROJECT

echo $BASEDIR

PKG=${PWD##*/}
LIBS1=`grep -o '"\.\.\/.*"' $BASEDIR/pyproject.toml | sed -e 's/"//g' | cut -d/ -f4 | grep -v "^$"`
DOMAIN="domain"
if test -f "poetry.lock"; then
  LIBS2=`grep -o '"\.\.\/\.\..*"' $BASEDIR/poetry.lock | sed -e 's/"//g' | cut -d/ -f4 | grep -v "^$"`
fi
DEPS=$(echo "${LIBS1}\n${LIBS2}" | sort --unique)

mkdir -p $BASEDIR/dist/deps

echo "Building dependencies:"
echo $DEPS

# Build domain
cd $MONOREPODIR/domain
rm -rf ./dist/*
poetry build
cp dist/*.whl $BASEDIR/dist/deps/.
cd $BASEDIR

# Build dependencies
for dep in $DEPS; do
  cd $MONOREPODIR/lib/$dep
  rm -rf ./dist/*
  poetry build
  cp dist/*.whl $BASEDIR/dist/deps/.
  cd $BASEDIR
done

# Build the project
cd $BASEDIR
poetry build