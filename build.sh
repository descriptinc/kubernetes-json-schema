#!/bin/bash -xe

# This script uses openapi2jsonschema to generate a set of JSON schemas for
# the specified Kubernetes versions in three different flavours:
#
#   X.Y.Z - URL referenced based on the specified GitHub repository
#   X.Y.Z-standalone - de-referenced schemas, more useful as standalone documents
#   X.Y.Z-standalone-strict - de-referenced schemas, more useful as standalone documents, additionalProperties disallowed
#   X.Y.Z-local - relative references, useful to avoid the network dependency

declare -a arr=(
    # Add here the version you want to re-generate
    v1.18.17
)

for version in "${arr[@]}"
do
schema=https://raw.githubusercontent.com/kubernetes/kubernetes/${version}/api/openapi-spec/swagger.json
prefix=https://kubernetesjsonschema.dev/${version}/_definitions.json

.venv/bin/openapi2jsonschema -o "${version}-standalone-strict" --expanded --kubernetes --stand-alone --strict "${schema}"
.venv/bin/openapi2jsonschema -o "${version}-standalone" --expanded --kubernetes --stand-alone "${schema}"
.venv/bin/openapi2jsonschema -o "${version}-local" --expanded --kubernetes "${schema}"
.venv/bin/openapi2jsonschema -o "${version}" --expanded --kubernetes --prefix "${prefix}" "${schema}"
.venv/bin/openapi2jsonschema -o "${version}-standalone-strict" --kubernetes --stand-alone --strict "${schema}"
.venv/bin/openapi2jsonschema -o "${version}-standalone" --kubernetes --stand-alone "${schema}"
.venv/bin/openapi2jsonschema -o "${version}-local" --kubernetes "${schema}"
.venv/bin/openapi2jsonschema -o "${version}" --kubernetes --prefix "${prefix}" "${schema}"
done
