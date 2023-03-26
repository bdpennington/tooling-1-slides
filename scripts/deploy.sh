#!/bin/bash

set -xe

aws s3 rm s3://futuri-ci-builds/static-docs/bdpennington/slides/tooling-pkmgr-bundlers/
aws s3 sync dist s3://futuri-ci-builds/static-docs/bdpennington/slides/tooling-pkmgr-bundlers/

exit 0;
